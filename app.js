const FEATURE_ITEMS = [
  {
    title: "Label OCR",
    detail: "Upload a back-of-pack photo and extract ingredients plus macro text automatically.",
  },
  {
    title: "Camera barcode scanning",
    detail: "Use a browser camera stream and barcode detection when the device supports it.",
  },
  {
    title: "Automatic judgment",
    detail: "Get a usable recommendation based on trigger density, macro context, and ingredient quality.",
  },
];

const INDIA_TAGS = [
  "Refined palmolein oil",
  "Vanaspati",
  "Maida",
  "Milk solids",
  "Whey solids",
  "Liquid glucose",
  "INS 407",
  "INS 211",
  "Class II preservative",
  "Nature identical flavors",
];

const LEARN_ITEMS = [
  [
    "Gut triggers",
    "High-sugar fillers, maltodextrin, refined flour, and some stabilizers can show up together in ultra-processed snacks and increase the overall trigger load.",
  ],
  [
    "Inflammatory oils",
    "Sunflower-heavy blends, palmolein-rich products, and vague frying oils are worth extra scrutiny when they appear alongside flavor systems and preservatives.",
  ],
  [
    "Hormonal triggers",
    "Dairy concentrates like whey solids, skim milk powder, and casein may be worth limiting if scalp oiliness or breakouts consistently worsen after intake.",
  ],
  [
    "Yeast-feeding patterns",
    "Sugar plus yeast-related additives in the same product is usually a stronger warning than either one by itself.",
  ],
];

const RECOMMEND_ITEMS = [
  "Prefer shorter ingredient lists with recognizable whole-food components.",
  "Choose roasted, baked, or minimally flavored snacks more often than shelf-stable ultra-processed ones.",
  "Look for olive oil, nuts, seeds, legumes, oats, and unsweetened dairy alternatives when possible.",
  "If a packaged item uses multiple oils, multiple sweeteners, and multiple additives together, treat it as a higher-friction choice.",
];

const SAMPLE_INPUTS = {
  clean:
    "Ingredients: Water, roasted chana protein, cocoa powder, stevia leaf extract, almonds, oats, olive oil. Protein 18g. Sugar 2g. Fat 7g.",
  risky:
    "Ingredients: Sugar, refined palmolein oil, maltodextrin, artificial flavors, yeast extract, INS 211, maida. Energy 420 kcal. Sugar 26g. Fat 18g. Protein 4g.",
  dairy:
    "Ingredients: Skim milk powder, whey solids, casein, liquid glucose, stabilizer INS 407, milk solids, vanaspati. Protein 22g. Added sugar 18g. Total fat 12g.",
};

const PRODUCT_DB = {
  "8901030895483": {
    mode: "Barcode scan",
    name: "Masala Protein Puffs",
    ingredients:
      "Ingredients: Corn grits, refined palmolein oil, maltodextrin, yeast extract, acidity regulator, artificial flavors, INS 211. Energy 468 kcal. Protein 7g. Sugar 9g. Total fat 21g.",
  },
  "8902080000121": {
    mode: "Barcode scan",
    name: "Chocolate Nutrition Drink",
    ingredients:
      "Ingredients: Skim milk powder, sugar, whey solids, cocoa solids, stabilizer INS 407, vanaspati, added flavors. Protein 17g. Added sugar 24g. Fat 11g.",
  },
};

const TRIGGER_DB = [
  {
    key: "sugar",
    label: "Sugar",
    severity: "high",
    focus: "skin",
    category: "gut",
    aliases: ["sugar", "added sugar", "sucrose"],
    note: "Rapidly feeds yeast activity and increases glycemic pressure.",
  },
  {
    key: "liquid glucose",
    label: "Liquid glucose",
    severity: "high",
    focus: "skin",
    category: "gut",
    aliases: ["liquid glucose", "glucose syrup", "corn syrup solids"],
    note: "Fast-absorbing sugar source that can amplify gut-trigger patterns.",
  },
  {
    key: "maltodextrin",
    label: "Maltodextrin",
    severity: "high",
    focus: "skin+hair",
    category: "gut",
    aliases: ["maltodextrin"],
    note: "Highly processed carbohydrate that often behaves worse than plain sugar in labels.",
  },
  {
    key: "yeast extract",
    label: "Yeast extract",
    severity: "high",
    focus: "skin",
    category: "yeast",
    aliases: ["yeast extract", "autolyzed yeast", "brewers yeast", "nutritional yeast"],
    note: "Yeast-related additive that can be a bad fit for yeast-sensitive routines.",
  },
  {
    key: "refined palmolein oil",
    label: "Refined palmolein oil",
    severity: "high",
    focus: "skin+hair",
    category: "inflammatory",
    aliases: ["refined palmolein oil", "palmolein", "palm oil"],
    note: "Common in Indian packaged foods and often a sign of a more inflammatory product profile.",
  },
  {
    key: "sunflower oil",
    label: "Sunflower oil",
    severity: "high",
    focus: "skin+hair",
    category: "inflammatory",
    aliases: ["sunflower oil"],
    note: "High omega-6 oil that can be worth limiting in already processed foods.",
  },
  {
    key: "vanaspati",
    label: "Vanaspati",
    severity: "high",
    focus: "hair",
    category: "hormonal",
    aliases: ["vanaspati", "partially hydrogenated", "hydrogenated vegetable oil"],
    note: "Hydrogenated-fat style signal that raises the risk profile of the whole product.",
  },
  {
    key: "whey solids",
    label: "Whey solids",
    severity: "high",
    focus: "skin+hair",
    category: "hormonal",
    aliases: ["whey solids", "whey", "whey protein isolate"],
    note: "Dairy-linked trigger that may worsen oiliness or breakouts for some users.",
  },
  {
    key: "skim milk powder",
    label: "Skim milk powder",
    severity: "high",
    focus: "skin+hair",
    category: "hormonal",
    aliases: ["skim milk powder", "skim milk", "milk solids"],
    note: "Concentrated dairy solids can raise risk in dairy-sensitive routines.",
  },
  {
    key: "casein",
    label: "Casein",
    severity: "medium",
    focus: "skin+hair",
    category: "gut",
    aliases: ["casein", "sodium caseinate"],
    note: "Moderate dairy protein trigger that still matters in stacked labels.",
  },
  {
    key: "maida",
    label: "Maida",
    severity: "medium",
    focus: "skin",
    category: "gut",
    aliases: ["maida", "refined wheat flour", "enriched flour", "bleached flour"],
    note: "Refined flour that adds glycemic stress and lowers label quality.",
  },
  {
    key: "artificial flavors",
    label: "Artificial flavors",
    severity: "medium",
    focus: "skin",
    category: "inflammatory",
    aliases: ["artificial flavors", "added flavors", "nature identical flavoring substances"],
    note: "Low-transparency flavor system often paired with other processed triggers.",
  },
  {
    key: "ins 407",
    label: "INS 407",
    severity: "medium",
    focus: "skin",
    category: "gut",
    aliases: ["ins 407", "407", "carrageenan", "stabilizer 407"],
    note: "Mapped to carrageenan-style stabilizer risk.",
  },
  {
    key: "ins 211",
    label: "INS 211",
    severity: "medium",
    focus: "skin",
    category: "inflammatory",
    aliases: ["ins 211", "211", "sodium benzoate", "class ii preservative"],
    note: "Common preservative code with a moderate inflammatory signal.",
  },
  {
    key: "acidity regulator",
    label: "Acidity regulator",
    severity: "low",
    focus: "skin",
    category: "gut",
    aliases: ["acidity regulator", "citric acid"],
    note: "Usually mild alone, but useful context when stacked with larger triggers.",
  },
];

const STORAGE_KEY = "sebscan-history-v4";
const USERS_KEY = "sebscan-users-v2";
const ACTIVE_USER_KEY = "sebscan-active-user-v2";

const config = window.SEBSCAN_CONFIG || {};
const hasSupabaseConfig = Boolean(config.supabaseUrl && config.supabaseAnonKey && window.supabase);
const supabaseClient = hasSupabaseConfig ? window.supabase.createClient(config.supabaseUrl, config.supabaseAnonKey) : null;

const state = {
  currentScreen: "home",
  filter: "all",
  history: [],
  lastResult: null,
  activeUser: loadActiveUser(),
  scannerInstance: null,
  scannerRunning: false,
  scannerSupported: Boolean(window.Html5Qrcode),
  isIOS: /iPhone|iPad|iPod/i.test(navigator.userAgent),
  selectedImageFile: null,
  ocrRunning: false,
};

const elements = {
  featureList: document.getElementById("featureList"),
  indiaTags: document.getElementById("indiaTags"),
  recentStrip: document.getElementById("recentStrip"),
  ingredientsInput: document.getElementById("ingredientsInput"),
  analyzeButton: document.getElementById("analyzeButton"),
  ocrImageInput: document.getElementById("ocrImageInput"),
  ocrPreviewShell: document.getElementById("ocrPreviewShell"),
  ocrPreviewImage: document.getElementById("ocrPreviewImage"),
  ocrButton: document.getElementById("ocrButton"),
  ocrStatus: document.getElementById("ocrStatus"),
  startScannerButton: document.getElementById("startScannerButton"),
  stopScannerButton: document.getElementById("stopScannerButton"),
  scannerReader: document.getElementById("scannerReader"),
  scannerPlaceholder: document.getElementById("scannerPlaceholder"),
  barcodeInput: document.getElementById("barcodeInput"),
  barcodeLookupButton: document.getElementById("barcodeLookupButton"),
  scannerStatus: document.getElementById("scannerStatus"),
  riskScore: document.getElementById("riskScore"),
  resultTitle: document.getElementById("resultTitle"),
  resultSummary: document.getElementById("resultSummary"),
  resultMode: document.getElementById("resultMode"),
  triggerList: document.getElementById("triggerList"),
  insightList: document.getElementById("insightList"),
  filterRow: document.getElementById("filterRow"),
  historyList: document.getElementById("historyList"),
  chartBars: document.getElementById("chartBars"),
  streakCount: document.getElementById("streakCount"),
  learnList: document.getElementById("learnList"),
  recommendList: document.getElementById("recommendList"),
  totalScans: document.getElementById("totalScans"),
  safePicks: document.getElementById("safePicks"),
  watchHits: document.getElementById("watchHits"),
  heroScore: document.getElementById("heroScore"),
  heroCaption: document.getElementById("heroCaption"),
  resultConfidence: document.getElementById("resultConfidence"),
  resultFocus: document.getElementById("resultFocus"),
  resultJudgment: document.getElementById("resultJudgment"),
  macroGrid: document.getElementById("macroGrid"),
  ruleCount: document.getElementById("ruleCount"),
  aliasCount: document.getElementById("aliasCount"),
  authState: document.getElementById("authState"),
  authName: document.getElementById("authName"),
  authEmail: document.getElementById("authEmail"),
  authPassword: document.getElementById("authPassword"),
  signUpButton: document.getElementById("signUpButton"),
  signInButton: document.getElementById("signInButton"),
  signOutButton: document.getElementById("signOutButton"),
  headerAuthButton: document.getElementById("headerAuthButton"),
  userBadge: document.getElementById("userBadge"),
  profileNote: document.getElementById("profileNote"),
  databaseStatus: document.getElementById("databaseStatus"),
};

const dataService = createDataService();

bootstrap();

async function bootstrap() {
  renderStaticSections();
  wireEvents();
  await refreshHistory();
  seedResult();
  renderHistory();
  renderProfile();
  renderRecent();
  setScreen("home");
  updateScannerAvailability();
}

function renderStaticSections() {
  elements.featureList.innerHTML = FEATURE_ITEMS.map(
    (item) => `
      <article class="info-card">
        <strong>${item.title}</strong>
        <p>${item.detail}</p>
      </article>
    `
  ).join("");

  elements.indiaTags.innerHTML = INDIA_TAGS.map((tag) => `<span class="tag">${tag}</span>`).join("");
  elements.learnList.innerHTML = LEARN_ITEMS.map(
    ([title, body]) => `
      <details class="accordion-item">
        <summary>${title}</summary>
        <p>${body}</p>
      </details>
    `
  ).join("");
  elements.recommendList.innerHTML = RECOMMEND_ITEMS.map((item) => `<article class="info-card"><p>${item}</p></article>`).join("");
  elements.ruleCount.textContent = TRIGGER_DB.length;
  elements.aliasCount.textContent = TRIGGER_DB.reduce((sum, item) => sum + item.aliases.length, 0);
  elements.databaseStatus.textContent = hasSupabaseConfig
    ? "Database mode: Supabase connected for hosted auth and saved scans."
    : "Database mode: local preview fallback. Add Supabase config in config.js to use hosted auth and storage.";
}

function wireEvents() {
  document.querySelectorAll("[data-nav]").forEach((button) => {
    button.addEventListener("click", () => setScreen(button.dataset.nav));
  });

  document.querySelectorAll("[data-action]").forEach((button) => {
    button.addEventListener("click", () => {
      const action = button.dataset.action;
      if (action === "manual") {
        setScreen("scan");
        elements.ingredientsInput.focus();
        return;
      }
      setScreen("scan");
      if (action === "barcode") {
        startScanner();
      }
    });
  });

  document.querySelectorAll("[data-sample]").forEach((button) => {
    button.addEventListener("click", () => {
      elements.ingredientsInput.value = SAMPLE_INPUTS[button.dataset.sample];
    });
  });

  elements.ocrImageInput.addEventListener("change", handleImageSelection);
  elements.ocrButton.addEventListener("click", extractLabelTextFromImage);

  elements.analyzeButton.addEventListener("click", async () => {
    const input = elements.ingredientsInput.value.trim();
    if (!input) {
      showToast("Paste ingredients or run OCR first.");
      return;
    }
    await runAnalysis({
      mode: "Manual scan",
      name: inferProductName(input),
      ingredients: input,
    });
  });

  elements.startScannerButton.addEventListener("click", startScanner);
  elements.stopScannerButton.addEventListener("click", stopScanner);
  elements.barcodeLookupButton.addEventListener("click", handleManualBarcodeLookup);
  elements.barcodeInput.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      handleManualBarcodeLookup();
    }
  });
  elements.headerAuthButton.addEventListener("click", () => setScreen("profile"));
  elements.signUpButton.addEventListener("click", signUp);
  elements.signInButton.addEventListener("click", signIn);
  elements.signOutButton.addEventListener("click", signOut);
  elements.authPassword.addEventListener("keydown", (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      signIn();
    }
  });
}

function setScreen(name) {
  if (state.currentScreen === "scan" && name !== "scan") {
    stopScanner();
  }
  state.currentScreen = name;
  document.querySelectorAll(".screen").forEach((screen) => {
    screen.classList.toggle("active", screen.dataset.screen === name);
  });
  document.querySelectorAll(".nav-tab").forEach((item) => {
    item.classList.toggle("active", item.dataset.nav === name);
  });
}

function updateScannerAvailability() {
  if (!state.scannerSupported) {
    elements.scannerStatus.textContent = "Live barcode detection is not supported in this browser. Use manual barcode entry instead.";
    elements.startScannerButton.disabled = true;
    return;
  }

  if (state.isIOS) {
    elements.scannerStatus.textContent = "iPhone is supported, but camera scanning works best after allowing camera access and using good lighting.";
  }
}

function handleImageSelection(event) {
  const file = event.target.files?.[0];
  state.selectedImageFile = file || null;
  if (!file) {
    elements.ocrPreviewShell.classList.add("hidden");
    return;
  }
  const reader = new FileReader();
  reader.onload = () => {
    elements.ocrPreviewImage.src = reader.result;
    elements.ocrPreviewShell.classList.remove("hidden");
  };
  reader.readAsDataURL(file);
}

async function extractLabelTextFromImage() {
  if (!state.selectedImageFile) {
    showToast("Select a label image first.");
    return;
  }
  if (!window.Tesseract) {
    showToast("OCR library is unavailable.");
    return;
  }
  if (state.ocrRunning) return;

  state.ocrRunning = true;
  elements.ocrButton.disabled = true;
  elements.analyzeButton.disabled = true;
  elements.ocrStatus.textContent = "Running OCR on the uploaded label...";
  try {
    const processedSource = await preprocessImage(state.selectedImageFile);
    const result = await window.Tesseract.recognize(processedSource, "eng", {
      logger: (message) => {
        if (message.status === "recognizing text") {
          elements.ocrStatus.textContent = `Running OCR... ${Math.round((message.progress || 0) * 100)}%`;
        }
      },
    });
    const text = isolateRelevantLabelText(cleanOcrText(result.data.text.trim()));
    if (!text) {
      elements.ocrStatus.textContent = "No readable label text was detected.";
      showToast("Could not read the label clearly.");
      return;
    }
    elements.ingredientsInput.value = cleanOcrText(text);
    elements.ocrStatus.textContent = "OCR complete. Running analysis on the extracted label.";
    await runAnalysis({
      mode: "OCR scan",
      name: "Uploaded label",
      ingredients: text,
    });
  } catch (error) {
    elements.ocrStatus.textContent = "OCR failed. Try a clearer image.";
    showToast("OCR failed.");
  } finally {
    state.ocrRunning = false;
    elements.ocrButton.disabled = false;
    elements.analyzeButton.disabled = false;
  }
}

async function startScanner() {
  if (!state.scannerSupported) return;
  if (state.scannerRunning) return;
  try {
    elements.startScannerButton.disabled = true;
    await stopScanner();
    state.scannerInstance = new Html5Qrcode("scannerReader");
    elements.scannerPlaceholder.classList.add("hidden");
    elements.scannerStatus.textContent = "Scanner running. Point the camera at a barcode.";
    const scannerConfig = {
      fps: 10,
      qrbox: { width: 220, height: 140 },
      rememberLastUsedCamera: true,
      aspectRatio: 1.333334,
      formatsToSupport: [
        Html5QrcodeSupportedFormats.EAN_13,
        Html5QrcodeSupportedFormats.EAN_8,
        Html5QrcodeSupportedFormats.UPC_A,
        Html5QrcodeSupportedFormats.UPC_E,
        Html5QrcodeSupportedFormats.CODE_128,
      ],
    };
    const onSuccess = async (decodedText) => {
      if (!decodedText) return;
      state.scannerRunning = false;
      elements.scannerStatus.textContent = `Detected barcode ${decodedText}. Looking up product...`;
      await stopScanner();
      await lookupBarcode(decodedText);
    };
    const onFrame = () => {
      elements.scannerStatus.textContent = "Scanner is active. Hold steady over the barcode.";
    };

    try {
      await state.scannerInstance.start({ facingMode: "environment" }, scannerConfig, onSuccess, onFrame);
    } catch {
      const cameras = await Html5Qrcode.getCameras();
      const preferredCamera =
        cameras.find((camera) => /back|rear|environment/i.test(camera.label))?.id ||
        cameras[0]?.id;
      if (!preferredCamera) {
        throw new Error("No camera available");
      }
      await state.scannerInstance.start(preferredCamera, scannerConfig, onSuccess, onFrame);
    }
    state.scannerRunning = true;
  } catch {
    elements.scannerStatus.textContent = state.isIOS
      ? "Could not start live scanning on iPhone. Use the label photo upload or manual barcode lookup instead."
      : "Could not access the camera. Check browser permissions and try again.";
    showToast("Camera access failed.");
    elements.startScannerButton.disabled = false;
  }
}

async function stopScanner() {
  if (state.scannerInstance) {
    try {
      if (state.scannerRunning) {
        await state.scannerInstance.stop();
      }
      await state.scannerInstance.clear();
    } catch {}
    state.scannerInstance = null;
  }
  state.scannerRunning = false;
  elements.scannerPlaceholder.classList.remove("hidden");
  elements.startScannerButton.disabled = false;
}

async function handleManualBarcodeLookup() {
  const code = elements.barcodeInput.value.trim();
  if (!code) {
    showToast("Enter a barcode first.");
    return;
  }
  await lookupBarcode(code);
}

async function lookupBarcode(code) {
  const normalizedCode = normalizeBarcode(code);
  const product = (await fetchOpenFoodFactsProduct(normalizedCode)) || PRODUCT_DB[normalizedCode];
  if (!product) {
    elements.barcodeInput.value = normalizedCode;
    elements.scannerStatus.textContent =
      `No public product match found for ${normalizedCode}. Try the label photo upload or use one of the demo fallback barcodes below.`;
    showToast("No product match found. Use photo upload or a demo fallback code.");
    return;
  }
  await runAnalysis({
    mode: product.mode,
    name: product.name,
    ingredients: product.ingredients,
  });
}

function normalizeBarcode(code) {
  const digitsOnly = String(code || "").replace(/[^\d]/g, "");
  if (!digitsOnly) return String(code || "").trim();
  return digitsOnly;
}

function getBarcodeCandidates(code) {
  const clean = normalizeBarcode(code);
  const candidates = [clean];
  if (clean.length === 12) candidates.push(`0${clean}`);
  if (clean.length === 13 && clean.startsWith("0")) candidates.push(clean.slice(1));
  return [...new Set(candidates.filter(Boolean))];
}

function cleanOcrText(text) {
  return text
    .replace(/\r/g, " ")
    .replace(/\n{2,}/g, "\n")
    .replace(/[|]/g, "I")
    .replace(/[^\S\r\n]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function isolateRelevantLabelText(text) {
  const lower = text.toLowerCase();
  const startCandidates = ["ingredients", "ingredient list", "contains"];
  let startIndex = -1;
  for (const candidate of startCandidates) {
    const index = lower.indexOf(candidate);
    if (index !== -1) {
      startIndex = index;
      break;
    }
  }

  const relevant = startIndex !== -1 ? text.slice(startIndex) : text;
  const endMarkers = ["allergen", "manufactured", "storage", "fssai", "customer care"];
  let endIndex = relevant.length;
  const relevantLower = relevant.toLowerCase();
  for (const marker of endMarkers) {
    const idx = relevantLower.indexOf(marker);
    if (idx !== -1 && idx < endIndex) {
      endIndex = idx;
    }
  }
  return relevant.slice(0, endIndex).trim();
}

async function preprocessImage(file) {
  const dataUrl = await fileToDataUrl(file);
  const image = await loadImage(dataUrl);
  const canvas = document.createElement("canvas");
  const maxWidth = 1600;
  const scale = Math.min(1, maxWidth / image.width);
  canvas.width = Math.max(1, Math.round(image.width * scale));
  canvas.height = Math.max(1, Math.round(image.height * scale));
  const ctx = canvas.getContext("2d");
  ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const data = imageData.data;

  for (let i = 0; i < data.length; i += 4) {
    const gray = (data[i] * 0.299) + (data[i + 1] * 0.587) + (data[i + 2] * 0.114);
    const contrast = gray > 140 ? 255 : gray < 85 ? 0 : gray;
    data[i] = contrast;
    data[i + 1] = contrast;
    data[i + 2] = contrast;
  }

  ctx.putImageData(imageData, 0, 0);
  return canvas;
}

function fileToDataUrl(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

function loadImage(src) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = reject;
    image.src = src;
  });
}

async function fetchOpenFoodFactsProduct(code) {
  for (const candidate of getBarcodeCandidates(code)) {
    try {
      const response = await fetch(`https://world.openfoodfacts.org/api/v0/product/${encodeURIComponent(candidate)}.json`);
      if (!response.ok) continue;
      const data = await response.json();
      if (data.status !== 1 || !data.product) continue;
      const product = data.product;
      return {
        mode: "Barcode scan",
        name: product.product_name || "Scanned product",
        ingredients: [
          product.ingredients_text || "",
          product.nutriments?.energy_kcal ? `Energy ${Math.round(product.nutriments.energy_kcal)} kcal.` : "",
          product.nutriments?.proteins_100g ? `Protein ${product.nutriments.proteins_100g}g.` : "",
          product.nutriments?.sugars_100g ? `Sugar ${product.nutriments.sugars_100g}g.` : "",
          product.nutriments?.fat_100g ? `Fat ${product.nutriments.fat_100g}g.` : "",
        ]
          .filter(Boolean)
          .join(" "),
      };
    } catch {}
  }
  return null;
}

function normalizeInput(text) {
  return text
    .toLowerCase()
    .replace(/\([^)]*\)/g, " ")
    .replace(/[-_/]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function extractMacros(text) {
  const normalized = text.toLowerCase();
  const pick = (patterns) => {
    for (const pattern of patterns) {
      const match = normalized.match(pattern);
      if (match) return match[1];
    }
    return null;
  };

  return {
    calories: pick([/(\d+(?:\.\d+)?)\s*kcal/, /energy\s*[:\-]?\s*(\d+(?:\.\d+)?)/]),
    protein: pick([/protein\s*[:\-]?\s*(\d+(?:\.\d+)?)\s*g/]),
    sugar: pick([/added sugar\s*[:\-]?\s*(\d+(?:\.\d+)?)\s*g/, /sugar\s*[:\-]?\s*(\d+(?:\.\d+)?)\s*g/]),
    fat: pick([/total fat\s*[:\-]?\s*(\d+(?:\.\d+)?)\s*g/, /fat\s*[:\-]?\s*(\d+(?:\.\d+)?)\s*g/]),
  };
}

function getJudgment(score, macros) {
  const sugar = Number(macros.sugar || 0);
  const protein = Number(macros.protein || 0);

  if (score >= 75 || sugar >= 20) {
    return "Avoid regularly";
  }
  if (score >= 45 || (sugar >= 10 && protein < 10)) {
    return "Occasional only";
  }
  if (protein >= 12 && score <= 35) {
    return "Good fit";
  }
  return "Usually fine";
}

function analyzeIngredients(text) {
  const normalized = normalizeInput(text);
  const macros = extractMacros(text);
  const seen = new Set();
  const matches = [];

  TRIGGER_DB.forEach((trigger) => {
    const hit = trigger.aliases.find((alias) => normalized.includes(alias));
    if (hit && !seen.has(trigger.key)) {
      seen.add(trigger.key);
      matches.push({
        ...trigger,
        matchedAs: hit,
        score: trigger.severity === "high" ? 28 : trigger.severity === "medium" ? 16 : 8,
      });
    }
  });

  matches.sort((a, b) => severityRank(b.severity) - severityRank(a.severity));

  const baseScore = matches.reduce((sum, item) => sum + item.score, 0);
  const categoryBonus = new Set(matches.map((item) => item.category)).size * 4;
  const dualFocusBonus =
    matches.some((item) => item.focus.includes("skin")) &&
    matches.some((item) => item.focus.includes("hair"))
      ? 6
      : 0;
  const sugarPenalty = Number(macros.sugar || 0) >= 15 ? 8 : Number(macros.sugar || 0) >= 8 ? 4 : 0;

  const riskScore = clamp(Math.round(baseScore + categoryBonus + dualFocusBonus + sugarPenalty), 0, 100);
  const safeScore = 100 - riskScore;
  const confidence = clamp(60 + (matches.length * 7) + (normalized.length > 80 ? 8 : 0), 0, 99);
  const judgment = getJudgment(riskScore, macros);

  return {
    matches,
    macros,
    judgment,
    score: riskScore,
    safeScore,
    confidence,
    title: riskScore >= 70 ? "High trigger density" : riskScore >= 40 ? "Mixed label quality" : "Mostly clean read",
    summary:
      riskScore >= 70
        ? "This label stacks several processed, inflammatory, or dairy-linked triggers in one product."
        : riskScore >= 40
          ? "The ingredient deck shows a moderate trigger load. It may be manageable, but not ideal for a consistent routine."
          : "This scan looks relatively calm, with limited high-impact triggers detected by the current rule set.",
    focus: inferFocus(matches),
    insights: buildInsights(matches, riskScore, confidence, macros, judgment),
  };
}

function buildInsights(matches, score, confidence, macros, judgment) {
  if (!matches.length) {
    return [
      ["Clean read", "No major trigger patterns were found in this ingredient deck."],
      ["Macro context", macroSummary(macros)],
      ["Judgment", `${judgment} based on the current OCR or pasted label text.`],
      ["Confidence", `Prediction confidence is ${confidence}% because the label text was readable and specific.`],
    ];
  }

  const categoryCount = matches.reduce((acc, item) => {
    acc[item.category] = (acc[item.category] || 0) + 1;
    return acc;
  }, {});
  const strongest = Object.entries(categoryCount).sort((a, b) => b[1] - a[1])[0]?.[0] || "balanced";
  const normalizedHits = matches.filter((item) => item.matchedAs !== item.key).length;

  return [
    ["Score logic", `${matches.length} trigger matches across ${Object.keys(categoryCount).length} risk groups pushed the score to ${score}.`],
    ["Dominant pattern", `The strongest pressure came from ${strongest} triggers in this label.`],
    ["Macro context", macroSummary(macros)],
    ["Normalization", normalizedHits ? `${normalizedHits} hits came through synonym or additive-code matching.` : "This scan matched mostly direct ingredient names."],
    ["Judgment", `${judgment} based on ingredient risk, macro profile, and label quality.`],
    ["Confidence", `Analysis confidence is ${confidence}% for this scan.`],
  ];
}

function macroSummary(macros) {
  const parts = [];
  if (macros.calories) parts.push(`${macros.calories} kcal`);
  if (macros.protein) parts.push(`${macros.protein}g protein`);
  if (macros.sugar) parts.push(`${macros.sugar}g sugar`);
  if (macros.fat) parts.push(`${macros.fat}g fat`);
  return parts.length ? `Extracted macro hints: ${parts.join(", ")}.` : "No clear macro values were extracted from this label.";
}

function inferFocus(matches) {
  const skin = matches.filter((item) => item.focus.includes("skin")).length;
  const hair = matches.filter((item) => item.focus.includes("hair")).length;
  if (skin && hair) return "Focus: skin + hair";
  if (hair) return "Focus: hair";
  if (skin) return "Focus: skin";
  return "Focus: balanced";
}

function inferProductName(input) {
  const compact = input.split(".")[0].split(",")[0].trim();
  if (compact.length > 36) return "Manual label scan";
  return compact ? `Scan: ${compact}` : "Manual label scan";
}

async function runAnalysis({ mode, name, ingredients }) {
  const result = analyzeIngredients(ingredients);
  const entry = {
    id: Date.now(),
    mode,
    name,
    ingredients,
    timestamp: new Date().toISOString(),
    userEmail: state.activeUser?.email || null,
    ...result,
  };

  state.lastResult = entry;
  await dataService.saveScan(entry, state.activeUser);
  await refreshHistory();
  renderResults();
  renderHistory();
  renderProfile();
  renderRecent();
  setScreen("results");
}

function previewAnalysis({ mode, name, ingredients }) {
  state.lastResult = {
    id: 0,
    mode,
    name,
    ingredients,
    timestamp: new Date().toISOString(),
    userEmail: state.activeUser?.email || null,
    ...analyzeIngredients(ingredients),
  };
  renderResults();
}

function renderResults() {
  const result = state.lastResult;
  if (!result) return;

  elements.riskScore.textContent = result.score;
  elements.resultTitle.textContent = result.title;
  elements.resultSummary.textContent = result.summary;
  elements.resultMode.textContent = `${result.mode} • ${result.name}`;
  elements.resultConfidence.textContent = `Confidence ${result.confidence}%`;
  elements.resultFocus.textContent = result.focus;
  elements.resultJudgment.textContent = `Judgment: ${result.judgment}`;
  elements.macroGrid.innerHTML = renderMacroGrid(result.macros);
  document.querySelector(".gauge-ring").style.setProperty("--score", result.score);
  document.querySelector(".gauge-ring").style.setProperty(
    "--gauge-color",
    result.score >= 70 ? "var(--danger)" : result.score >= 40 ? "var(--warning)" : "var(--success)"
  );
  elements.heroScore.textContent = result.safeScore;
  elements.heroCaption.textContent =
    result.score >= 70 ? "Heavy trigger load" : result.score >= 40 ? "Mixed processed load" : "Low trigger risk";

  renderFilterChips(result.matches);
  renderTriggerCards(result.matches);
  elements.insightList.innerHTML = result.insights
    .map(
      ([title, body]) => `
        <article class="info-card">
          <strong>${title}</strong>
          <p>${body}</p>
        </article>
      `
    )
    .join("");
}

function renderMacroGrid(macros) {
  const items = [
    ["Calories", macros.calories ? `${macros.calories} kcal` : "Not found"],
    ["Protein", macros.protein ? `${macros.protein} g` : "Not found"],
    ["Sugar", macros.sugar ? `${macros.sugar} g` : "Not found"],
    ["Fat", macros.fat ? `${macros.fat} g` : "Not found"],
  ];
  return items
    .map(
      ([label, value]) => `
        <article class="macro-card">
          <span>${label}</span>
          <strong>${value}</strong>
        </article>
      `
    )
    .join("");
}

function renderFilterChips(matches) {
  const categories = ["all", "skin", "hair", "high"];
  elements.filterRow.innerHTML = categories
    .map((category) => {
      const count =
        category === "all"
          ? matches.length
          : category === "high"
            ? matches.filter((item) => item.severity === "high").length
            : matches.filter((item) => item.focus.includes(category)).length;
      return `
        <button class="filter-chip ${state.filter === category ? "active" : ""}" data-filter="${category}">
          ${capitalize(category)} (${count})
        </button>
      `;
    })
    .join("");

  document.querySelectorAll("[data-filter]").forEach((button) => {
    button.addEventListener("click", () => {
      state.filter = button.dataset.filter;
      renderFilterChips(matches);
      renderTriggerCards(matches);
    });
  });
}

function renderTriggerCards(matches) {
  const filtered =
    state.filter === "all"
      ? matches
      : state.filter === "high"
        ? matches.filter((item) => item.severity === "high")
        : matches.filter((item) => item.focus.includes(state.filter));

  elements.triggerList.innerHTML = filtered.length
    ? filtered
        .map(
          (item) => `
            <article class="trigger-card">
              <div>
                <strong>${item.label}</strong>
                <p>${item.note}</p>
                <p class="trigger-meta">Matched as ${item.matchedAs} • ${capitalize(item.category)} • ${item.focus.replace("+", " + ")}</p>
              </div>
              <span class="severity-pill severity-${item.severity}">${capitalize(item.severity)}</span>
            </article>
          `
        )
        .join("")
    : '<article class="trigger-card"><div><strong>No matches in this filter</strong><p>Try All, Skin, Hair, or High to inspect the full scan.</p></div></article>';
}

async function refreshHistory() {
  state.history = await dataService.getScans(state.activeUser);
}

function renderHistory() {
  const history = state.history;
  const counts = {
    gut: 0,
    inflammatory: 0,
    hormonal: 0,
    yeast: 0,
    safe: history.filter((item) => item.score < 40).length,
  };

  history.forEach((item) => {
    item.matches.forEach((match) => {
      counts[match.category] += 1;
    });
  });

  const values = [counts.gut, counts.inflammatory, counts.hormonal, counts.yeast, counts.safe || 1];
  const max = Math.max(...values, 1);
  elements.chartBars.innerHTML = values
    .map((value) => `<div class="chart-bar" style="height:${Math.max(18, (value / max) * 100)}%"></div>`)
    .join("");

  elements.streakCount.textContent = `${Math.min(history.filter((item) => item.score < 40).length || 0, 7)} safe scans`;
  elements.historyList.innerHTML = history.length
    ? history
        .map(
          (item) => `
            <article class="history-item">
              <strong>${item.name}</strong>
              <p>${item.mode} • Risk ${item.score} • ${item.judgment}</p>
              <p><code>${truncate(item.ingredients, 88)}</code></p>
            </article>
          `
        )
        .join("")
    : '<article class="history-item"><strong>No scans yet</strong><p>Run a scan to start building history for this account.</p></article>';
}

function renderProfile() {
  const history = state.history;
  const total = history.length;
  const safe = history.filter((item) => item.score < 40).length;
  const hits = history.reduce((sum, item) => sum + item.matches.length, 0);
  elements.totalScans.textContent = total;
  elements.safePicks.textContent = safe;
  elements.watchHits.textContent = hits;

  const user = state.activeUser;
  elements.authState.innerHTML = user
    ? `<div class="signed-in-card"><strong>${user.name || "User"}</strong><p>${user.email}</p></div>`
    : `<div class="signed-in-card"><strong>Guest mode</strong><p>Create an account to keep scans grouped to one profile in this demo.</p></div>`;
  elements.userBadge.textContent = user ? user.email : "Guest mode";
  elements.headerAuthButton.textContent = user ? "Account" : "Sign in";
  elements.signOutButton.classList.toggle("hidden", !user);
  elements.profileNote.textContent = user
    ? `Signed in as ${user.email}. New scans are associated with this account context.`
    : "Sign in to keep your scan history tied to one account in this demo.";
}

function renderRecent() {
  const items = state.history.slice(0, 5);
  elements.recentStrip.innerHTML = (items.length ? items : seedRecentCards())
    .map((item) =>
      typeof item === "string"
        ? item
        : `
          <article class="recent-card">
            <p class="eyebrow">${item.mode}</p>
            <strong>${item.name}</strong>
            <p>${item.judgment} • Risk ${item.score}</p>
          </article>
        `
    )
    .join("");
}

async function signUp() {
  const name = elements.authName.value.trim();
  const email = elements.authEmail.value.trim().toLowerCase();
  const password = elements.authPassword.value;
  if (!name || !email || !password) {
    showToast("Fill in name, email, and password.");
    return;
  }
  const user = await dataService.signUp({ name, email, password });
  if (!user) {
    showToast("Could not sign up. That email may already exist.");
    return;
  }
  state.activeUser = user;
  clearAuthForm();
  await refreshHistory();
  renderProfile();
  renderHistory();
  renderRecent();
  showToast("Account created.");
}

async function signIn() {
  const email = elements.authEmail.value.trim().toLowerCase();
  const password = elements.authPassword.value;
  const user = await dataService.signIn({ email, password });
  if (!user) {
    showToast("Incorrect email or password.");
    return;
  }
  state.activeUser = user;
  clearAuthForm();
  await refreshHistory();
  renderProfile();
  renderHistory();
  renderRecent();
  showToast("Signed in.");
}

async function signOut() {
  await dataService.signOut();
  state.activeUser = null;
  await refreshHistory();
  renderProfile();
  renderHistory();
  renderRecent();
  showToast("Signed out.");
}

function clearAuthForm() {
  elements.authName.value = "";
  elements.authEmail.value = "";
  elements.authPassword.value = "";
}

function seedRecentCards() {
  return [
    '<article class="recent-card"><p class="eyebrow">Preview</p><strong>Roasted Chana Protein</strong><p>Good fit • Risk 12</p></article>',
    '<article class="recent-card"><p class="eyebrow">Preview</p><strong>Masala Protein Puffs</strong><p>Avoid regularly • Risk 82</p></article>',
    '<article class="recent-card"><p class="eyebrow">Preview</p><strong>Chocolate Nutrition Drink</strong><p>Avoid regularly • Risk 90</p></article>',
  ];
}

function seedResult() {
  if (state.history.length) {
    state.lastResult = state.history[0];
    renderResults();
    return;
  }
  previewAnalysis({
    mode: "Preview",
    name: "Roasted Chana Protein",
    ingredients: SAMPLE_INPUTS.clean,
  });
}

function createDataService() {
  if (hasSupabaseConfig) {
    return createSupabaseService();
  }
  return createLocalDataService();
}

function createLocalDataService() {
  return {
    async signUp({ name, email, password }) {
      const users = loadUsers();
      if (users.some((user) => user.email === email)) return null;
      const user = { id: Date.now(), name, email, password };
      users.push(user);
      saveUsers(users);
      saveActiveUser(user);
      return user;
    },
    async signIn({ email, password }) {
      const users = loadUsers();
      const user = users.find((item) => item.email === email && item.password === password);
      if (!user) return null;
      saveActiveUser(user);
      return user;
    },
    async signOut() {
      localStorage.removeItem(ACTIVE_USER_KEY);
    },
    async saveScan(entry, activeUser) {
      const history = loadHistory();
      history.unshift({
        ...entry,
        userEmail: activeUser?.email || null,
      });
      localStorage.setItem(STORAGE_KEY, JSON.stringify(history.slice(0, 30)));
    },
    async getScans(activeUser) {
      const history = loadHistory();
      if (!activeUser) return history.filter((item) => !item.userEmail);
      return history.filter((item) => item.userEmail === activeUser.email);
    },
  };
}

function createSupabaseService() {
  return {
    async signUp({ name, email, password }) {
      try {
        const { data, error } = await supabaseClient.auth.signUp({
          email,
          password,
          options: {
            data: { name },
          },
        });
        if (error || !data.user) return null;
        const user = { id: data.user.id, name, email };
        saveActiveUser(user);
        return user;
      } catch {
        return null;
      }
    },
    async signIn({ email, password }) {
      try {
        const { data, error } = await supabaseClient.auth.signInWithPassword({ email, password });
        if (error || !data.user) return null;
        const user = {
          id: data.user.id,
          name: data.user.user_metadata?.name || email.split("@")[0],
          email,
        };
        saveActiveUser(user);
        return user;
      } catch {
        return null;
      }
    },
    async signOut() {
      try {
        await supabaseClient.auth.signOut();
      } catch {}
      localStorage.removeItem(ACTIVE_USER_KEY);
    },
    async saveScan(entry, activeUser) {
      if (!activeUser) return;
      try {
        await supabaseClient.from("scans").insert({
          user_id: activeUser.id || null,
          user_email: activeUser.email,
          product_name: entry.name,
          mode: entry.mode,
          ingredients: entry.ingredients,
          risk_score: entry.score,
          confidence: entry.confidence,
          judgment: entry.judgment,
          macros: entry.macros,
          matches: entry.matches,
          created_at: entry.timestamp,
        });
      } catch {}
    },
    async getScans(activeUser) {
      if (!activeUser) return [];
      try {
        const { data } = await supabaseClient
          .from("scans")
          .select("*")
          .eq("user_email", activeUser.email)
          .order("created_at", { ascending: false });
        return (data || []).map((item) => ({
          id: item.id || Date.now(),
          name: item.product_name,
          mode: item.mode,
          ingredients: item.ingredients,
          score: item.risk_score,
          confidence: item.confidence,
          judgment: item.judgment,
          macros: item.macros || {},
          matches: item.matches || [],
          timestamp: item.created_at,
          userEmail: item.user_email,
          focus: inferFocus(item.matches || []),
          title: item.risk_score >= 70 ? "High trigger density" : item.risk_score >= 40 ? "Mixed label quality" : "Mostly clean read",
          summary: "",
          insights: [],
        }));
      } catch {
        return [];
      }
    },
  };
}

function loadHistory() {
  try {
    return JSON.parse(localStorage.getItem(STORAGE_KEY) || "[]");
  } catch {
    return [];
  }
}

function loadUsers() {
  try {
    return JSON.parse(localStorage.getItem(USERS_KEY) || "[]");
  } catch {
    return [];
  }
}

function saveUsers(users) {
  localStorage.setItem(USERS_KEY, JSON.stringify(users));
}

function loadActiveUser() {
  try {
    return JSON.parse(localStorage.getItem(ACTIVE_USER_KEY) || "null");
  } catch {
    return null;
  }
}

function saveActiveUser(user) {
  localStorage.setItem(ACTIVE_USER_KEY, JSON.stringify(user));
}

function severityRank(severity) {
  if (severity === "high") return 3;
  if (severity === "medium") return 2;
  return 1;
}

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function capitalize(value) {
  return value.charAt(0).toUpperCase() + value.slice(1);
}

function truncate(value, limit) {
  return value.length > limit ? `${value.slice(0, limit)}...` : value;
}

function showToast(message) {
  const toast = document.createElement("div");
  toast.className = "toast";
  toast.textContent = message;
  document.body.appendChild(toast);
  setTimeout(() => toast.remove(), 1800);
}
