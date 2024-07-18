const main = '/tmp/ags/main.js';
const entry = `${App.configDir}/main.ts`;

async function compile() {
	// prettier-ignore
	await Utils.execAsync([
		"esbuild", "--format=esm",
		"--bundle", entry,
		`--outfile=${main}`,
		"--external:resource://*",
		"--external:gi://*",
		"--external:file://*",
	]);

	await import(`file://${main}`);
}

compile().catch((e) => console.error(`\n${e}`));
