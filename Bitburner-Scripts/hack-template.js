/** @param {NS} ns */
export async function main(ns) {
  const target = "target";
  const moneyThresh = ns.getServerMaxMoney(target);

  {
    if (ns.getServerMoneyAvailable(target) < moneyThresh) {
      await ns.hack(target);
    } else {
      await ns.sleep(60000)
    }
  }
}