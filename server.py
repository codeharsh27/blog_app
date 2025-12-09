from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import sys
import os

# Add the lib directory to the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), 'lib')))

from tech_news_engine.scrapper.techcrunch import scrape_techcrunch

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/news':
            try:
                # Get news from your scraper
                news_data = scrape_techcrunch()
                
                # Create response
                response = {
                    'status': 'success',
                    'articles': news_data
                }
                
                # Convert to JSON and validate
                json_response = json.dumps(response, ensure_ascii=False)
                
                # Log the response size for debugging
                print(f'Sending response of size: {len(json_response)} bytes')
                
                # Send headers
                self.send_response(200)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.send_header('Content-Length', str(len(json_response)))
                self.end_headers()
                
                # Send response in chunks to avoid large response issues
                chunk_size = 4096
                for i in range(0, len(json_response), chunk_size):
                    chunk = json_response[i:i+chunk_size]
                    self.wfile.write(chunk.encode('utf-8'))
                
            except Exception as e:
                error_msg = str(e)
                print(f'Error in /news endpoint: {error_msg}')
                error_response = json.dumps({
                    'status': 'error',
                    'message': error_msg
                }, ensure_ascii=False)
                
                self.send_response(500)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.send_header('Access-Control-Allow-Origin', '*')
                self.send_header('Content-Length', str(len(error_response)))
                self.end_headers()
                self.wfile.write(error_response.encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()
            self.wfile.write(b'Not Found')

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting server on port {port}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()
