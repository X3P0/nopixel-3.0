const ResourceName = GetCurrentResourceName();

let IsDebugEnabled = GetConvar('sv_environment', 'production') === 'debug';

const __AddLibEvent = (pEvent, pCallback) => {
    if (IsDuplicityVersion()) {
        on(pEvent, pCallback);
    } else {
        onNet(pEvent, pCallback);
    }
};

__AddLibEvent('np-dev:enableDebug', (pEnabled, pResource) => {
    if (pResource !== undefined && pResource !== ResourceName) return;

    IsDebugEnabled = pEnabled;
});

function Debug(...args) {
    if (!IsDebugEnabled) return;

    console.log('^3[DEBUG]^7', `[${new Date().toISOString()}]:`, ...args);
}
