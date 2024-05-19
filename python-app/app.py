import http.server
import socketserver

PORT = 5000
FILE_PATH = '/app/samplefile'

class FileContentHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        with open(FILE_PATH, 'rb') as file:
            self.wfile.write(file.read())

if __name__ == "__main__":
    with socketserver.TCPServer(("", PORT), FileContentHandler) as httpd:
        print("Serving at port", PORT)
        httpd.serve_forever()