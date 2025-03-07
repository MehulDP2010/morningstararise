from flask import Flask, request, jsonify, render_template
from flask_socketio import SocketIO
import re

app = Flask(__name__)
socketio = SocketIO(app)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/handle_payload', methods=['POST'])
def handle_payload():
    data = request.data.decode('utf-8')  # Get plain text payload from request

    # Use regular expressions to extract the values from the message
    match = re.search(r'order (\w+) @ (\d+) filled on (\w+). New strategy position is (\d+)', data)
    if match:
        order_action, contracts, ticker, position_size = match.groups()

        # Convert the contracts and position size to integers
        contracts = int(contracts)
        position_size = int(position_size)

        # Create a dictionary with the values
        data_dict = {
            'order_action': order_action,
            'contracts': contracts,
            'ticker': ticker,
            'position_size': position_size
        }

        # Process the values here. For example, you can print them to the console:
        print(f'Order Action: {order_action}, Contracts: {contracts}, Ticker: {ticker}, Position Size: {position_size}')

        # Emit the data to all connected clients
        socketio.emit('new_data', data_dict)

        return jsonify({'message': 'Data received', 'status': 'success'}), 200
    else:
        return jsonify({'message': 'Invalid data format', 'status': 'error'}), 400
    
if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=80)