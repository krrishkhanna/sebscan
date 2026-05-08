# SebScan Web App

SebScan is a web app that scans food labels, extracts ingredient and macro information, and gives an explainable trigger-risk judgment for seborrheic dermatitis and hair-fall routines.

## Run

Use any static server from this folder. For example:

```bash
python3 -m http.server 4173
```

Then open `http://localhost:4173`.

## Included flows

- Manual ingredient analysis
- OCR-based label text extraction using `Tesseract.js`
- Browser barcode scanning with `BarcodeDetector` where supported
- Macro extraction from nutrition text
- Automatic judgment based on triggers and macro context
- Account flow with local preview auth or hosted Supabase-ready auth
- Scan history and result explanations
- Parallel Flutter codebase in `sebscan/` for the native app version

## Database mode

- Works immediately with local preview persistence
- Supports hosted Supabase auth + scan storage when you add your keys to `config.js`
- SQL schema is in [supabase-schema.sql](/Users/kkk/SebScan1/supabase-schema.sql)

Setup note:
- Copy [config.example.js](/Users/kkk/SebScan1/config.example.js) into `config.js` if you want to swap projects later. Only use a public browser-safe Supabase publishable/anon key there.

## Deployment

GitHub Pages deployment notes are in [DEPLOY.md](/Users/kkk/SebScan1/DEPLOY.md).
