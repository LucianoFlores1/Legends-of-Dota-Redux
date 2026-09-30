const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");
const { getAddonName, getDotaPath } = require("./utils");

(async () => {
	const dotaPath = await getDotaPath();
	const addon = getAddonName();

	const steamPaths = ["C:\\Program Files (x86)\\Steam\\steam.exe", "C:\\Program Files\\Steam\\steam.exe"];
	const steamExe = steamPaths.find((p) => fs.existsSync(p));

	if (process.platform === "win32" && steamExe) {
		const child = spawn(steamExe, ["-applaunch", "570", "-tools", "-addon", addon], {
			detached: true,
			stdio: "ignore",
		});
		child.unref();
		return;
	}

	const win64 = path.join(dotaPath, "game", "bin", "win64");
	const args = ["-tools", "-addon", addon];
	const child = spawn(path.join(win64, "dota2.exe"), args, {
		detached: true,
		stdio: "ignore",
		cwd: win64,
	});
	child.unref();
})().catch((error) => {
	console.error(error);
	process.exit(1);
});
