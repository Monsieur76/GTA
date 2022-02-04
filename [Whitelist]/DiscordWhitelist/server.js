//////////////////////////////////////////
//           Discord Whitelist          //
//////////////////////////////////////////

/// Config Area ///

var guild = "871460329287200838";
var botToken = "OTIzMjA5MzM0NDk2ODQxODA5.YcMrsQ.2KMWx4tlmjiR4pNjckTAPs8a7lM";

var whitelistRoles = [ // Roles by ID that are whitelisted.
    "881572272199057429"
    //"923533339858718750"
]

var blacklistRoles = [ // Roles by Id that are blacklisted.
    ""
]

var notWhitelistedMessage = "Vous ne pouvez pas rejoindre le serveur. Rejoignez notre Discord pour rejoindre la Whitelist"
var noGuildMessage = "Guild Not Detected. It seems you're not in the guild for this community."
var blacklistMessage = "Vous êtes Blacklist du serveur"
var debugMode = true

/// Code ///
const axios = require('axios').default;
axios.defaults.baseURL = 'https://discord.com/api/v8';
axios.defaults.headers = {
    'Content-Type': 'application/json',
    Authorization: `Bot ${botToken}`
};
function getUserDiscord(source) {
    if(typeof source === 'string') return source;
    if(!GetPlayerName(source)) return false;
    for(let index = 0; index <= GetNumPlayerIdentifiers(source); index ++) {
        if (GetPlayerIdentifier(source, index).indexOf('discord:') !== -1) return GetPlayerIdentifier(source, index).replace('discord:', '');
    }
    return false;
}
on('playerConnecting', (name, setKickReason, deferrals) => {
    let src = global.source;
    deferrals.defer();
    var userId = getUserDiscord(src);

    setTimeout(() => {
        deferrals.update(`Bonjour ${name}. Nous vérifions si vous avez le rôle nécessaire pour rentrer sur le serveur.`)
        setTimeout(async function() {
            if(userId) {
                axios(`/guilds/${guild}/members/${userId}`).then((resDis) => {
                    if(!resDis.data) {
                        if(debugMode) console.log(`'${name}' with ID '${userId}' cannot be found in the assigned guild and was not granted access.`);
                        return deferrals.done(noGuildMessage);
                    }
                    const hasRole = typeof whitelistRoles === 'string' ? resDis.data.roles.includes(whitelistRoles) : resDis.data.roles.some((cRole, i) => resDis.data.roles.includes(whitelistRoles[i]));
                    const hasBlackRole = typeof blacklistRoles === 'string' ? resDis.data.roles.includes(blacklistRoles) : resDis.data.roles.some((cRole, i) => resDis.data.roles.includes(blacklistRoles[i]));
                    if(hasBlackRole) {
                        if(debugMode) console.log(`'${name}' with ID '${userId}' is blacklisted to join this server.`);
                        return deferrals.done(blacklistMessage);
                    }
                    if(hasRole) {
                        if(debugMode) console.log(`'${name}' ID '${userId}' à passé la WL et rentre sur le serveur.`);
                        return deferrals.done();
                    }
                }).catch((err) => {
                    if(debugMode) console.log(`^1There was an issue with the Discord API request. Is the guild ID & bot token correct?^7`);
                });
            } else {
                if(debugMode) console.log(`'${name}' was not granted access as a Discord identifier could not be found.`);
                return deferrals.done(`Discord n'est pas détecté. Merci de le lancer pour pouvoir rejoindre le serveur.`);
            }
        }, 0)
    }, 0)
})