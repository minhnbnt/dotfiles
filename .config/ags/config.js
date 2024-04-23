const main = '/tmp/ags/main.js';
const entry = `${App.configDir}/main.ts`;

async function compile() {
    // prettier-ignore
    await Utils.execAsync([
		'bun', 'build', entry,
		'--outfile', main,
		'-e', 'resource://*',
		'-e', 'gi://*'
	]);

    await import(`file://${main}`);
}

compile().catch((e) => console.log(`\n${e}`));
