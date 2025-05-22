from flask import Flask, request, jsonify, render_template_string
from transformers import MarianMTModel, MarianTokenizer
from flask_cors import CORS
import itertools

app = Flask(__name__)
CORS(app)

# Model önbelleği
loaded_models = {}

# Desteklenen diller ve özellikleri
SUPPORTED_LANGUAGES = {
    "tr": {"name": "Türkçe", "flag": "🇹🇷"},
    "en": {"name": "İngilizce", "flag": "🇬🇧"},
    "de": {"name": "Almanca", "flag": "🇩🇪"},
    "fr": {"name": "Fransızca", "flag": "🇫🇷"},
    "es": {"name": "İspanyolca", "flag": "🇪🇸"}
}

def get_model_name(source_lang, target_lang):
    """Kaynak ve hedef dile göre model adını belirle"""
    # Doğrudan çeviri modelleri
    direct_models = {
        ("tr", "en"): "Helsinki-NLP/opus-mt-tr-en",
        ("en", "tr"): "Helsinki-NLP/opus-mt-en-trk",
        ("en", "de"): "Helsinki-NLP/opus-mt-en-de",
        ("de", "en"): "Helsinki-NLP/opus-mt-de-en",
        ("en", "fr"): "Helsinki-NLP/opus-mt-en-fr",
        ("fr", "en"): "Helsinki-NLP/opus-mt-fr-en",
        ("en", "es"): "Helsinki-NLP/opus-mt-en-es",
        ("es", "en"): "Helsinki-NLP/opus-mt-es-en",
        ("de", "fr"): "Helsinki-NLP/opus-mt-de-fr",
        ("fr", "de"): "Helsinki-NLP/opus-mt-fr-de",
        ("de", "es"): "Helsinki-NLP/opus-mt-de-es",
        ("es", "de"): "Helsinki-NLP/opus-mt-es-de",
        ("fr", "es"): "Helsinki-NLP/opus-mt-fr-es",
        ("es", "fr"): "Helsinki-NLP/opus-mt-es-fr"
    }

    # Doğrudan model varsa onu kullan
    if (source_lang, target_lang) in direct_models:
        return direct_models[(source_lang, target_lang)], False

    # Köprü çeviri gerekiyorsa (İngilizce üzerinden)
    if source_lang != "en" and target_lang != "en":
        source_to_en = direct_models.get((source_lang, "en"))
        en_to_target = direct_models.get(("en", target_lang))
        if source_to_en and en_to_target:
            return [source_to_en, en_to_target], True

    raise ValueError(f"Desteklenmeyen dil çifti: {source_lang} -> {target_lang}")

def load_model(model_name):
    """Model ve tokenizer'ı yükle"""
    if model_name in loaded_models:
        return loaded_models[model_name]

    print(f"📦 Model yükleniyor: {model_name}")
    try:
        model = MarianMTModel.from_pretrained(model_name)
        tokenizer = MarianTokenizer.from_pretrained(model_name)
        loaded_models[model_name] = (model, tokenizer)
        return model, tokenizer
    except Exception as e:
        print(f"🔥 Model yükleme hatası: {str(e)}")
        raise e

def translate_text(text, model, tokenizer):
    """Metni çevir"""
    try:
        # Metni parçalara böl (uzun metinler için)
        max_length = 512
        chunks = [text[i:i+max_length] for i in range(0, len(text), max_length)]
        translated_chunks = []

        for chunk in chunks:
            encoded = tokenizer.encode(chunk, return_tensors="pt", padding=True, truncation=True)
            output = model.generate(
                encoded,
                max_length=max_length,
                num_beams=4,
                early_stopping=True,
                length_penalty=0.6
            )
            translated_chunk = tokenizer.decode(output[0], skip_special_tokens=True)
            translated_chunks.append(translated_chunk)

        return " ".join(translated_chunks)
    except Exception as e:
        print(f"🔥 Çeviri hatası: {str(e)}")
        raise e

def translate_with_bridge(text, source_lang, target_lang):
    """İki adımlı çeviri yap (İngilizce üzerinden)"""
    try:
        # İlk çeviri: Kaynak dilden İngilizceye
        model_name = get_model_name(source_lang, "en")[0]
        model1, tokenizer1 = load_model(model_name)
        english_text = translate_text(text, model1, tokenizer1)
        print(f"🔄 Ara çeviri (İngilizce): {english_text}")

        # İkinci çeviri: İngilizceden hedef dile
        model_name = get_model_name("en", target_lang)[0]
        model2, tokenizer2 = load_model(model_name)
        final_text = translate_text(english_text, model2, tokenizer2)

        return final_text
    except Exception as e:
        print(f"🔥 Köprü çeviri hatası: {str(e)}")
        raise e

@app.route('/translate', methods=['POST'])
def translate_route():
    try:
        data = request.get_json()
        source_text = data.get("text", "")
        source_lang = data.get("source_lang", "").lower()
        target_lang = data.get("target_lang", "").lower()

        if not source_text.strip():
            return jsonify({"error": "Metin boş olamaz"}), 400

        if not source_lang or not target_lang:
            return jsonify({"error": "Kaynak ve hedef dil belirtilmeli"}), 400

        if source_lang not in SUPPORTED_LANGUAGES:
            return jsonify({"error": f"Kaynak dil desteklenmiyor: {source_lang}"}), 400

        if target_lang not in SUPPORTED_LANGUAGES:
            return jsonify({"error": f"Hedef dil desteklenmiyor: {target_lang}"}), 400

        if source_lang == target_lang:
            return jsonify({
                "input": source_text,
                "translated": source_text,
                "error": None,
                "method": "same"
            })

        try:
            model_info = get_model_name(source_lang, target_lang)

            if model_info[1]:  # Köprü çeviri gerekiyor
                print(f"🌉 Köprü çeviri başlatılıyor: {source_lang} -> EN -> {target_lang}")
                translated_text = translate_with_bridge(source_text, source_lang, target_lang)
            else:  # Doğrudan çeviri
                print(f"🎯 Doğrudan çeviri başlatılıyor: {source_lang} -> {target_lang}")
                model, tokenizer = load_model(model_info[0])
                translated_text = translate_text(source_text, model, tokenizer)

            return jsonify({
                "input": source_text,
                "translated": translated_text,
                "error": None,
                "method": "bridge" if model_info[1] else "direct",
                "source_language": SUPPORTED_LANGUAGES[source_lang],
                "target_language": SUPPORTED_LANGUAGES[target_lang]
            })

        except ValueError as e:
            return jsonify({"error": str(e)}), 400

    except Exception as e:
        print("🔥 HATA:", str(e))
        return jsonify({"error": str(e)}), 500

def generate_language_pairs_html():
    """Tüm dil çiftleri için HTML oluştur"""
    pairs_html = ""
    for source, target in itertools.permutations(SUPPORTED_LANGUAGES.items(), 2):
        source_code, source_info = source
        target_code, target_info = target
        is_bridge = source_code != "en" and target_code != "en"
        pair_class = "language-pair bridge" if is_bridge else "language-pair"
        pairs_html += f"""
        <div class="{pair_class}">
            {source_info['flag']} {source_info['name']} → {target_info['flag']} {target_info['name']}
        </div>
        """
    return pairs_html

# Ana sayfa HTML template'i
HOME_PAGE = """
<!DOCTYPE html>
<html>
<head>
    <title>Çok Dilli Çeviri API</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #1D1B20;
            color: white;
        }
        .container {
            background-color: #2D2B30;
            padding: 20px;
            border-radius: 12px;
            margin-top: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #E63946;
            margin-bottom: 30px;
            text-align: center;
        }
        .endpoint {
            background-color: #333;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        .method {
            color: #E63946;
            font-weight: bold;
        }
        .url {
            color: #4CAF50;
        }
        pre {
            background-color: #1D1B20;
            padding: 15px;
            border-radius: 8px;
            overflow-x: auto;
            font-size: 14px;
        }
        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 4px;
            background-color: #4CAF50;
            color: white;
            margin-bottom: 20px;
        }
        .language-pair {
            background-color: #333;
            padding: 10px;
            border-radius: 4px;
            margin: 5px;
            display: inline-block;
            transition: transform 0.2s;
        }
        .language-pair:hover {
            transform: scale(1.05);
        }
        .bridge {
            color: #FFA500;
        }
        .language-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 10px;
            margin: 20px 0;
        }
        h2 {
            color: #4CAF50;
            margin-top: 30px;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            margin: 10px 0;
            padding: 10px;
            background-color: #333;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Çok Dilli Çeviri API'si</h1>
        <div class="status">Aktif ✅</div>

        <h2>Desteklenen Dil Çiftleri</h2>
        <div class="language-grid">
            """ + generate_language_pairs_html() + """
        </div>

        <h2>Kullanım</h2>
        <div class="endpoint">
            <p><span class="method">POST</span> <span class="url">/translate</span></p>
            <h4>İstek Formatı:</h4>
            <pre>
{
    "text": "Çevrilecek metin",
    "source_lang": "tr",
    "target_lang": "de"
}
            </pre>
            <h4>Yanıt Formatı:</h4>
            <pre>
{
    "input": "Çevrilecek metin",
    "translated": "Çevrilmiş metin",
    "error": null,
    "method": "bridge",  // veya "direct"
    "source_language": {"name": "Türkçe", "flag": "🇹🇷"},
    "target_language": {"name": "Almanca", "flag": "🇩🇪"}
}
            </pre>
        </div>

        <h2>Dil Kodları</h2>
        <ul>
            """ + "\n".join(
    [f'<li>{info["flag"]} {info["name"]}: {code}</li>' for code, info in SUPPORTED_LANGUAGES.items()]) + """
        </ul>
    </div>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(HOME_PAGE)

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5050, debug=True) 