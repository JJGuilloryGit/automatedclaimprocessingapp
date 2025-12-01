from flask import Flask, request, jsonify, render_template_string
import os

app = Flask(__name__)

HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Claim AI - File Upload</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 50px auto; padding: 20px; }
        .container { background: #f5f5f5; padding: 30px; border-radius: 10px; }
        .upload-area { border: 2px dashed #ccc; padding: 40px; text-align: center; margin: 20px 0; }
        button { background: #007bff; color: white; padding: 12px 24px; border: none; border-radius: 5px; cursor: pointer; margin: 10px; }
        button:hover { background: #0056b3; }
        .result { margin: 20px 0; padding: 15px; background: #e9ecef; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏥 Claim AI - Document Processing</h1>
        <p>Upload your claim documents (PDF, PNG, JPG) for AI-powered processing.</p>
        
        <form id="uploadForm" enctype="multipart/form-data">
            <div class="upload-area">
                <input type="file" id="fileInput" name="file" accept=".pdf,.png,.jpg,.jpeg" required>
                <p>Select a file to upload</p>
            </div>
            <button type="submit">📤 Upload File</button>
            <button type="button" onclick="processFile()">⚡ Process Claim</button>
        </form>
        
        <div id="result" class="result" style="display:none;"></div>
    </div>
    
    <script>
        document.getElementById('uploadForm').onsubmit = function(e) {
            e.preventDefault();
            const formData = new FormData();
            const fileInput = document.getElementById('fileInput');
            formData.append('file', fileInput.files[0]);
            
            fetch('/upload', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('result').style.display = 'block';
                document.getElementById('result').innerHTML = '<h3>Upload Result:</h3><pre>' + JSON.stringify(data, null, 2) + '</pre>';
            })
            .catch(error => {
                document.getElementById('result').style.display = 'block';
                document.getElementById('result').innerHTML = '<h3>Error:</h3><p>' + error + '</p>';
            });
        };
        
        function processFile() {
            fetch('/process', {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('result').style.display = 'block';
                document.getElementById('result').innerHTML = '<h3>Processing Result:</h3><pre>' + JSON.stringify(data, null, 2) + '</pre>';
            })
            .catch(error => {
                document.getElementById('result').style.display = 'block';
                document.getElementById('result').innerHTML = '<h3>Error:</h3><p>' + error + '</p>';
            });
        }
    </script>
</body>
</html>
'''

@app.route('/')
def hello():
    return render_template_string(HTML_TEMPLATE)

@app.route('/health')
def health():
    return {"status": "healthy"}, 200

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return {"error": "No file provided"}, 400
    
    file = request.files['file']
    if file.filename == '':
        return {"error": "No file selected"}, 400
    
    # Basic file validation
    allowed_extensions = {'pdf', 'png', 'jpg', 'jpeg'}
    if '.' not in file.filename or file.filename.rsplit('.', 1)[1].lower() not in allowed_extensions:
        return {"error": "Invalid file type. Only PDF, PNG, JPG allowed"}, 400
    
    return {
        "message": "File uploaded successfully", 
        "filename": file.filename,
        "size": len(file.read()),
        "status": "ready_for_processing"
    }, 200

@app.route('/process', methods=['POST'])
def process_claim():
    return {
        "message": "Claim processing initiated",
        "claim_id": "CLM-001",
        "status": "processing",
        "estimated_time": "2-3 minutes"
    }, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)