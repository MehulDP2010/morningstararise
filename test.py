import yfinance as yf

# List of stock symbols
stocks = ["RELIANCE.NS", "TCS.NS", "INFY.NS", "HDFCBANK.NS"]

# Fetch and display prices
for stock_symbol in stocks:
    stock = yf.Ticker(stock_symbol)
    stock_data = stock.history(period="1d")
    latest_price = stock_data["Close"].iloc[-1]
    print(f"Latest price of {stock_symbol}: ₹{latest_price:.2f}")
