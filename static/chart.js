const chart = LightweightCharts.createChart(document.getElementById('chartContainer'), {
    width: 800,
    height: 400,
    layout: {
        background: { color: '#ffffff' },
        textColor: '#000000'
    },
    grid: {
        vertLines: { color: '#e1ecf2' },
        horzLines: { color: '#e1ecf2' }
    }
});

const candlestickSeries = chart.addCandlestickSeries();

async function fetchData() {
    try {
        const response = await fetch('/api/nifty');
        if (!response.ok) throw new Error("Failed to fetch data");

        const rawData = await response.json();

        // Convert API response into chart-compatible format
        const chartData = rawData.map(item => ({
            time: item.time,  // UNIX timestamp
            open: item.open,
            high: item.high,
            low: item.low,
            close: item.close
        }));

        candlestickSeries.setData(chartData);  // Set data in the chart

    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

// Fetch data initially and update every 5 seconds
fetchData();
setInterval(fetchData, 5000);
