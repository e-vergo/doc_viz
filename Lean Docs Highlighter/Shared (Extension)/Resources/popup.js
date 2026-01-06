const DEFAULT_THEME = 'dark-highlighting';

async function setTheme(theme) {
    const tabs = await browser.tabs.query({ active: true, currentWindow: true });
    if (tabs[0]) {
        browser.tabs.sendMessage(tabs[0].id, { action: 'applyTheme', theme });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // Set default selection
    const defaultRadio = document.querySelector(`input[value="${DEFAULT_THEME}"]`);
    if (defaultRadio) {
        defaultRadio.checked = true;
    }

    // Listen for theme changes
    document.querySelectorAll('input[name="theme"]').forEach(radio => {
        radio.addEventListener('change', (e) => {
            if (e.target.checked) {
                setTheme(e.target.value);
            }
        });
    });
});
