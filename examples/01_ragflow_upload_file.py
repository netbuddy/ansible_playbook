# upload_to_kb.py  
import requests


def upload_file_to_kb(file_path, kb_name, token='ragflow-xxxxxxxxxxxxx', parser_id='naive'):
    """  
    Uploads a file to a knowledge base.  

    Args:  
    - file_path: Path to the file to upload.  
    - kb_name: Name of the target knowledge base.  
    - parser_id: ID of the chosen file parser (defaults to 'naive').  
    - token: API token for authentication.  
    """
    url = 'http://192.168.213.11:7080/v1/api/document/upload'  # Replace with your actual API URL  
    files = {'file': open(file_path, 'rb')}  # The file to upload  
    data = {'kb_name': kb_name, 'parser_id': parser_id, 'run': '0'}  # Additional form data  
    headers = {'Authorization': f'Bearer {token}'}  # Replace with your actual Bearer token  

    response = requests.post(url, files=files, data=data, headers=headers)

    if response.status_code == 200:
        print("File uploaded successfully:", response.json())
    else:
        print("Failed to upload file:", response.status_code, response.text)

file_to_upload = '/data/download/faq/faq.pdf'  # For example: './documents/report.pdf'  
knowledge_base_name = 'docker'
# Assume you have already obtained your token and set it here  
token = 'ragflow-cwZGYzYzRjOGI5MTExZWY5ZTIyMDI0Mm'

# Call the function to upload the file  
upload_file_to_kb(file_to_upload, knowledge_base_name, token=token)