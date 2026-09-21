-- hyprctl clients -j > ~/Downloads/windows.txt
hl.window_rule({
    name = "move-term",
    match = { class = "term1" },
    workspace = 1,
    float = false,
})

hl.window_rule({
    name = "move-chromium",
    match = { class = "chromium" },
    workspace = 2,
    float = false,
})

hl.window_rule({
    name = "move-brave-browser",
    match = { class = "brave-browser" },
    workspace = 3,
    float = false,
})

hl.window_rule({
    name = "move-code",
    match = { class = "code" },
    workspace = 12,
    float = false,
})

hl.window_rule({
    name = "move-slack",
    match = { class = "slack" },
    workspace = 13,
    float = false,
})

hl.window_rule({
    name = "move-obsidian",
    match = { class = "md.obsidian.Obsidian" },
    workspace = 14,
    float = false,
})

hl.window_rule({
    name = "move-bruno",
    match = { class = "bruno" },
    workspace = 16,
    float = false,
})

