# GitHub Pages + Supabase Setup

## 1. GitHub Pages

This app is static, so it can be deployed directly from the repository root on GitHub Pages.

Recommended repo structure:

- `index.html`
- `styles.css`
- `app.js`
- `config.example.js`
- `manifest.webmanifest`
- `.nojekyll`

## 2. Supabase

Create a Supabase project, then:

1. Run the SQL in [supabase-schema.sql](/Users/kkk/SebScan1/supabase-schema.sql)
2. Copy your project URL and anon key
3. Copy `config.example.js` to `config.js`
4. Put the values in `config.js`

Example:

```js
window.SEBSCAN_CONFIG = {
  supabaseUrl: "https://YOUR_PROJECT.supabase.co",
  supabaseAnonKey: "YOUR_PUBLIC_ANON_KEY",
};
```

## 3. Important note

`config.js` is public on GitHub Pages, so only place a public browser-safe anon key there, never a service role key.
