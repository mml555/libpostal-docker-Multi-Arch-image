"""
Libpostal HTTP Service
Provides address parsing via HTTP endpoint.
"""
from flask import Flask, request, jsonify
from postal.parser import parse_address

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint."""
    return jsonify({'status': 'ok'})

@app.route('/parser', methods=['POST'])
def parse():
    """
    Parse an address into components.
    
    Request body: { "text": "123 Main St, New York, NY 10001" }
    Response: [{"label": "house_number", "value": "123"}, ...]
    """
    data = request.get_json() or {}
    text = data.get('text', '')
    
    if not text:
        return jsonify({'error': 'text is required'}), 400
    
    try:
        # parse_address returns list of (value, label) tuples
        components = parse_address(text)
        result = [{'label': label, 'value': value} for value, label in components]
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4400)
