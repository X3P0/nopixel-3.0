const baseScriptSrc = 'np-inventory:scripts:';

const ignoreStartsWith = [
  'ply-',
];

let translationsObject = null;
let langCode = null;

let stringsToAdd = [];
const stringsProcessed = [];

setTimeout(async () => {
  while (translationsObject === null) {
    try {
      await new Promise((resolve) => setTimeout(resolve, 1000));
      const result = await (await fetch('https://np-ui/np-ui:i18n:getTranslations')).json();
      if (result.meta.ok) {
        translationsObject = result.data.translationsObject;
        langCode = result.data.langCode;
      }
    } catch (err) {
      console.log("i18n resource translations err", err.message, JSON.stringify(err));
    }
  }
  setInterval(async () => {
    try {
      const result = await (await fetch('https://np-ui/np-ui:i18n:getCurrentLangCode')).json();
      if (result.meta.ok) {
        langCode = result.data.langCode;
      }
    } catch (err) {
      console.log("i18n resource langcode err", err.message, JSON.stringify(err));
    }
  }, Math.floor(Math.random() * 5000 + 2000));
  setInterval(async () => {
    try {
      const strings = [];
      for (const str of stringsToAdd) {
        if (stringsProcessed.includes(str.string)) {
          continue;
        }
        stringsProcessed.push(str.string);
        strings.push(str);
      }
      stringsToAdd = [];
      if (strings.length === 0) {
        return;
      }
      await fetch('https://np-ui/np-ui:i18n:addStringsForTranslation', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ strings }),
      });
    } catch (err) {
      console.log("i18n resource addstring err", err.message, JSON.stringify(err));
    }
  }, Math.floor(Math.random() * 15000 + 5000));
}, 60000);

const reversalMap = {};

const _i18n = (str, src) => {
  if (!translationsObject || !langCode || !str || !isNaN(Number(str))) {
    return str;
  }
  if (langCode === 'en' && reversalMap[str]) {
    return reversalMap[str];
  }
  for (const i of ignoreStartsWith) {
    if (str.indexOf(i) === 0) {
      return str;
    }
  }
  const source = `${baseScriptSrc}${src || 'misc'}`;
  if (!stringsProcessed.includes(str) && langCode === 'en') {
    stringsToAdd.push({ string: str, source });
  }
  if (langCode === 'en') {
    return str;
  }
  if (
    translationsObject &&
    translationsObject[str] &&
    translationsObject[str][langCode]
  ) {
    reversalMap[translationsObject[str][langCode]] = str;
    return translationsObject[str][langCode];
  }
  return str;
}
