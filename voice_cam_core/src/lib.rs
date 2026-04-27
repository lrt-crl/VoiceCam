use tokio::net::TcpListener;
use tokio_tungstenite::accept_async;
use futures_util::StreamExt;
use std::sync::Arc;
use tokio::sync::Mutex;
use enigo::{Enigo, Keyboard, Settings};

pub async fn run_server() -> anyhow::Result<()> {
    let addr = "0.0.0.0:8080";
    let listener = TcpListener::bind(addr).await?;
    println!("WebSocket server listening on {}", addr);

    let enigo = Arc::new(Mutex::new(Enigo::new(&Settings::default()).unwrap()));

    while let Ok((stream, _)) = listener.accept().await {
        let enigo_clone = enigo.clone();
        tokio::spawn(async move {
            let ws_stream = accept_async(stream).await.expect("Error during the websocket handshake occurred");
            let (_, mut read) = ws_stream.split();

            while let Some(message) = read.next().await {
                if let Ok(msg) = message {
                    if msg.is_binary() {
                        let data = msg.into_data();
                        // Process data based on path (which we'd need to extract or use different ports)
                        // For STT:
                        // let text = transcribe(&data);
                        // let mut e = enigo_clone.lock().await;
                        // e.text(&text);
                    }
                }
            }
        });
    }
    Ok(())
}
