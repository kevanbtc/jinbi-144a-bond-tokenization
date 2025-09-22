from flask import Flask
app = Flask(__name__)
@app.route('/health', methods=['GET'])
def health():
    return {"status": "ok"}
    
@app.route('/version', methods=['GET'])
def version_info():  # Add new route for /version with a function that returns the app's current version information in JSON format: {'version': '1.0'}  
    return { "version" : "1.0"}    
if __name__ == '__main__':
   app.run(debug=True)  # run the application in debug mode on port 5000 (you can change it as per your needs). This is a good practice for development, but not recommended to use this command when deploying applications! Use gunicorn or uWSGI instead of Flask's built-in server.
