export async function main(ns) {
    const maxNodes = 12
    let interval = 10;

    while (true) {
        let moneyAvailable = ns.getServerMoneyAvailable("home");

        // Buy new Hacknet nodes if it's affordable and we haven't reached the max
        if (ns.hacknet.numNodes() < maxNodes && ns.hacknet.getPurchaseNodeCost() <= moneyAvailable) {
            ns.hacknet.purchaseNode();
            ns.tprint(`Purchased new Hacknet node. Total nodes: ${ns.hacknet.numNodes()}`);
        }

        // Loop over all existing Hacknet nodes and attempt to upgrade them
        for (let i = 0; i < ns.hacknet.numNodes(); i++) {
            const upgradeCosts = [
                { type: 'level', cost: ns.hacknet.getLevelUpgradeCost(i, 1) },
                { type: 'ram', cost: ns.hacknet.getRamUpgradeCost(i, 1) },
                { type: 'core', cost: ns.hacknet.getCoreUpgradeCost(i, 1) }
            ];

            // Sort upgrades by the cheapest option
            upgradeCosts.sort((a, b) => a.cost - b.cost);

            // Try to buy the cheapest upgrade if it's affordable
            if (upgradeCosts[0].cost <= moneyAvailable) {
                switch (upgradeCosts[0].type) {
                    case 'level':
                        ns.hacknet.upgradeLevel(i, 1);
                        ns.tprint(`Upgraded node ${i} level for ${upgradeCosts[0].cost}`);
                        break;
                    case 'ram':
                        ns.hacknet.upgradeRam(i, 1);
                        ns.tprint(`Upgraded node ${i} RAM for ${upgradeCosts[0].cost}`);
                        break;
                    case 'core':
                        ns.hacknet.upgradeCore(i, 1);
                        ns.tprint(`Upgraded node ${i} core for ${upgradeCosts[0].cost}`);
                        break;
                }
                moneyAvailable -= upgradeCosts[0].cost; // Deduct money spent
            }
        }

        await ns.sleep(interval); // Wait for the next cycle
    }
}