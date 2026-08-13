// assets/js/i18n.Js
(function () {
    let translations = {};
    let loadedLocale = null;
    let loadingPromise = null;

    function getLocale() {
        const htmlElement = document.documentElement;
        return htmlElement.dataset.locale || 'de';
    }

    async function loadTranslations(locale) {
        if (loadingPromise && loadedLocale === locale) {
            return loadingPromise;
        }

        loadingPromise = (async () => {
            try {
                const response = await fetch(`/i18n/${locale}.json`, {
                    cache: 'no-store'
                });

                if (!response.ok) {
                    console.error('Failed to load translations for locale:', locale);
                    translations = {};
                    loadedLocale = locale;
                    return;
                }

                translations = await response.json();
                loadedLocale = locale;
            } catch (error) {
                console.error('Error while loading translations:', error);
                translations = {};
                loadedLocale = locale;
            }
        })();

        return loadingPromise;
    }

    async function initTranslations() {
        const locale = getLocale();

        if (loadedLocale === locale && Object.keys(translations).length > 0) {
            return;
        }

        await loadTranslations(locale);
    }

    function t(key) {
        if (!translations || Object.keys(translations).length === 0) {
            return key;
        }

        return translations.hasOwnProperty(key) ? translations[key] : key;
    }

    window.i18nInit = initTranslations;
    window.t = t;
    window.getLocale = getLocale;
})();
