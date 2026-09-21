import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property var apps: []
    property bool loaded: false

    signal scanFinished()

    Component.onCompleted: scan()

    Process {
        id: scanProc
        command: ["bash", "-c", scanScript]
        stdout: StdioCollector {
            id: collector
            onStreamFinished: {
                try {
                    root.apps = JSON.parse(collector.text)
                } catch (e) {
                    console.log("Erreur parsing apps:", e)
                    root.apps = []
                }
                root.loaded = true
                root.scanFinished()
            }
        }
    }

    readonly property string scanScript: `
python3 -c "
import os, json, re

dirs = ['/usr/share/applications', '/usr/local/share/applications', os.path.expanduser('~/.local/share/applications')]
apps = []
seen = set()

for d in dirs:
    if not os.path.isdir(d):
        continue
    for f in os.listdir(d):
        if not f.endswith('.desktop'):
            continue
        path = os.path.join(d, f)
        try:
            with open(path, 'r', errors='ignore') as fp:
                content = fp.read()
        except:
            continue

        if 'NoDisplay=true' in content:
            continue

        name_match = re.search(r'^Name=(.+)$', content, re.MULTILINE)
        exec_match = re.search(r'^Exec=(.+)$', content, re.MULTILINE)
        icon_match = re.search(r'^Icon=(.+)$', content, re.MULTILINE)

        if not name_match or not exec_match:
            continue

        name = name_match.group(1).strip()
        if name in seen:
            continue
        seen.add(name)

        exec_cmd = exec_match.group(1).strip()
        exec_cmd = re.sub(r'%[a-zA-Z]', '', exec_cmd).strip()
        icon = icon_match.group(1).strip() if icon_match else 'application-x-executable'

        apps.append({'name': name, 'exec': exec_cmd, 'icon': icon})

apps.sort(key=lambda x: x['name'].lower())
print(json.dumps(apps))
"
`

    function launch(execString) {
        let parts = execString.split(" ").filter(p => p.length > 0)
        Quickshell.execDetached(parts)
    }
}