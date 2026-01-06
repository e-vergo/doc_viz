const DEFAULT_THEME = 'dark-highlighting';

// Apply theme by setting data attribute on HTML element
function applyTheme(theme) {
    document.documentElement.setAttribute('data-theme', theme);
}

// Apply default theme immediately (runs at document_start)
applyTheme(DEFAULT_THEME);

// Listen for theme change messages from popup
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === 'applyTheme') {
        applyTheme(request.theme);
        return Promise.resolve({ success: true });
    }
});
