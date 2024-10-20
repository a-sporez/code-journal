/** @param {NS} ns **/
export async function main(ns) {
    const servers = [
        { name: "n00dles", ports: 0, skill: 1, ram: 4 },
        { name: "foodnstuff", ports: 0, skill: 1, ram: 16 },
        { name: "sigma-cosmetics", ports: 0, skill: 5, ram: 16 },
        { name: "joesguns", ports: 0, skill: 10, ram: 16 },
        { name: "CSEC", ports: 1, skill: 60, ram: 8 },
        { name: "silver-helix", ports: 2, skill: 150, ram: 64 },
        { name: "hong-fang-tea", ports: 0, skill: 30, ram: 16 },
        { name: "nectar-net", ports: 0, skill: 20, ram: 16 },
        { name: "harakiri-sushi", ports: 0, skill: 40, ram: 16 },
        { name: "zer0", ports: 1, skill: 75, ram: 32 },
        { name: "phantasy", ports: 2, skill: 100, ram: 32 },
        // Add more servers as needed
    ];

    for (const server of servers) {
        if (!ns.hasRootAccess(server.name)) {
            // Open ports if necessary
            if (server.ports >= 1) ns.brutessh(server.name);
            if (server.ports >= 2) ns.ftpcrack(server.name);
            if (server.ports >= 3) ns.relaysmtp(server.name);
            if (server.ports >= 4) ns.httpworm(server.name);
            if (server.ports >= 5) ns.sqlinject(server.name);
            ns.nuke(server.name);
        }

        if (ns.hasRootAccess(server.name)) {
            // Optimize batching
            let secThresh = ns.getServerMinSecurityLevel(server.name) + 5;
            let moneyThresh = ns.getServerMaxMoney(server.name) * 0.75;

            while (true) {
                let currentSec = ns.getServerSecurityLevel(server.name);
                let currentMoney = ns.getServerMoneyAvailable(server.name);

                if (currentSec > secThresh) {
                    await ns.weaken(server.name);
                } else if (currentMoney < moneyThresh) {
                    await ns.grow(server.name);
                } else {
                    await ns.hack(server.name);
                }
            }
        }
    }
}