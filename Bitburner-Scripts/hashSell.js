/** @param {NS} ns **/
export async function main(ns) {

    const exchangeType = "Sell for Money";
    const hashCost = ns.hacknet.hashCost(exchangeType);
    
    while (true) {

        while (ns.hacknet.numHashes() >= hashCost) {
            const success = ns.hacknet.spendHashes(exchangeType);
            if (success) {
                ns.print(`Successfully exchanged hashes for: ${exchangeType}`);
            } else {
                ns.print("Failed to exchange hashes.");
            }
        }

        await ns.sleep(10000);
    }
}