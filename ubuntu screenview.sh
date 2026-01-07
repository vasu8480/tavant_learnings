hostname -I

x11vnc -display :0 -forever -shared -rfbport 5900 &
