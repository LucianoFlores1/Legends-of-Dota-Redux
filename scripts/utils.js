const fs = require("fs");
const path = require("path");
const packageJson = require("../package.json");

module.exports.getAddonName = () => {
	if (!/^[a-z][\d_a-z]+$/.test(packageJson.name)) {
		throw new Error(
			"Addon name may consist only of lowercase characters, digits, and underscores " +
				"and should start with a letter. Edit `name` field in `package.json` file.",
		);
	}

	return packageJson.name;
};

module.exports.getDotaPath = async () => {
	const commonPaths = [
		"C:\\Program Files (x86)\\Steam\\steamapps\\common\\dota 2 beta",
		"C:\\Program Files\\Steam\\steamapps\\common\\dota 2 beta",
		"D:\\SteamLibrary\\steamapps\\common\\dota 2 beta",
		"D:\\Steam\\steamapps\\common\\dota 2 beta",
		"E:\\SteamLibrary\\steamapps\\common\\dota 2 beta",
		"F:\\SteamLibrary\\steamapps\\common\\dota 2 beta",
	];

	for (const p of commonPaths) {
		if (fs.existsSync(p)) {
			return p;
		}
	}

	try {
		const { findSteamAppByName, SteamNotFoundError } = require("find-steam-app");
		return await findSteamAppByName("dota 2 beta");
	} catch (error) {
		// fallback
	}
};
