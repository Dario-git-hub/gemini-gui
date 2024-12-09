#!/bin/bash
pregunta=$(zenity --entry --text="Escribe una pregunta a Gemini")
echo '{
  "contents": [{
    "parts":[{"text": "Habla en español. Responde en texto plano, no en markdown. ${pregunta}"}]  
    }]
}' > /tmp/gemini.json
cat /tmp/gemini.json | sed "s/\${pregunta}/$pregunta/g" > /tmp/gemini.json

API_KEY=""

echo -e `curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${API_KEY}" -H 'Content-Type: application/json' -X POST -d @/tmp/gemini.json | grep -oP '"text":\s*"\K[^"]+'` >/tmp/respuesta-gemini 
zenity --info --text="`cat /tmp/respuesta-gemini`" &
espeak -f /tmp/respuesta-gemini -v mb-es1 #spanish

rm /tmp/gemini.json
rm /tmp/respuesta-gemini
