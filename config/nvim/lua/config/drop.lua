-- config/drop.lua
local M = {}

M.setup = function()
  require('drop').setup({
    theme = 'matrix',
    -- theme = 'auto',
    themes = {
      { theme = "new_year",            month = 1,                       day = 1 },
      { theme = "valentines_day",      month = 2,                       day = 14 },
      { theme = "st_patricks_day",     month = 3,                       day = 17 },
      { theme = "easter",              holiday = "easter" },
      { theme = "april_fools",         month = 4,                       day = 1 },
      { theme = "us_independence_day", month = 7,                       day = 4 },
      { theme = "halloween",           month = 10,                      day = 31 },
      { theme = "us_thanksgiving",     holiday = "us_thanksgiving" },
      { theme = "xmas",                from = { month = 12, day = 24 }, to = { month = 12, day = 25 } },
      { theme = "leaves",              from = { month = 9, day = 22 },  to = { month = 12, day = 20 } },
      { theme = "snow",                from = { month = 12, day = 21 }, to = { month = 3, day = 19 } },
      { theme = "spring",              from = { month = 3, day = 20 },  to = { month = 6, day = 20 } },
      { theme = "summer",              from = { month = 6, day = 21 },  to = { month = 9, day = 21 } },
    },
    max = 2000,
    interval = 50,
    screensaver = 1000 * 60 * 3,
    winblend = 0,
  })
end

return M

-- CURRENT AVAILABLE THEMES
-- april_fools - 🤡, 🎭, 🃏, 🎉, 😂, 🙃, 🎈, 🎁, 🤣, 😜
-- arcade - 🎮 🕹️ 👾 💾 ⚔️ 🛡️ 🏰
-- art - 🎨 🖼️ 🖌️ 🎭 🎶 📚 🖋️
-- bakery - 🍞 🥖 🥐 🍩 🍰 🧁 🍪
-- beach - 🌴 🏖️ 🍹 🌅 🏄 🐚 🌞
-- binary - 0, 1
-- bugs - 🐞, 🐜, 🪲, 🦗, 🕷️, 🕸️, 🐛
-- business - 💼, 🖊️, 📈, 📉, 💹, 💲, 🏢
-- candy - 🍬 🍭 🍫 🍩 🍰 🧁 🍪
-- cards - ♠️, ♥️, ♦️, ♣️, 🃏
-- carnival - 🎪 🎭 🍿 🎠 🎡 🎈 🤹
-- casino - 🎰 ♠️ ♦️ ♣️ ♥️ 🎲 🃏
-- cats - 🐱, 🦁, 🐯, 🐈, 🐅, 🐆
-- coffee - ☕ 🥐 🍰 🍪 🍩 🥛 🍫
-- cyberpunk - 🌃 💿 🕶️ ⚙️ 🖥️ 🎮 🔌
-- deepsea - 🐠 🐙 🦈 🌊 🦑 🐡 🐟
-- desert - 🌵 🐪 🏜️ 🌞 🦂 🪨 💧
-- dice - ⚀, ⚁, ⚂, ⚃, ⚄, ⚅
-- diner - 🍔 🍟 🥤 🍳 🥞 🥓 🍦
-- easter - 🐣 🐥 🐤 🥚 🌸 🍫 🐇 🌷 🌼 🍃 🦋 🍬 🌈 🎀 💒
-- emotional - 😀, 😃, 😄, 😁, 😆, 😅, 😂, 🤣, 😊, 😇, 🙂, 🙃, 😉, 😌, 😍, 😘, 😗, 😙, 😚, 😋, 😛, 😝, 😜, 🤪, 🤨, 🧐, 🤓, 😎, 🤩, 😏, 😒, 😞, 😔, 😟, 😕, 🙁, ☹️, 😣, 😖, 😫, 😩, 🥺, 😢, 😭, 😤, 😠, 😡, 🤬, 🤯, 😳, 🥵, 🥶, 😱, 😨, 😰, 😥, 😓, 😶, 😐, 😑, 😬, 😯, 😦, 😧, 😮, 😲, 🥱, 😴, 🤤, 😪, 😵, 🤐, 🥴, 🤢, 🤮, 🤕, 🤒, 😷, 🥰, 😸, 😺, 😻, 😼, 😽, 🙀, 😿, 😹
-- explorer - 🌍 🌐 🗺️ 🔍 ⛺ 🌄 🧭
-- fantasy - 🐉 🏰 🪄 🧙 🛡️ 🗡️ 🌌 👑
-- farm - 🐄 🐖 🐓 🌾 🍎 🍏 🚜
-- garden - 🌱, 🌸, 🌻, 🌿, 🍂, 🍃, 🌾
-- halloween - 🎃, 👻, 🦇, 🕷️, 🕸️, 🦉, 🔮, 💀, 👽, 🌙, 🍬, 🍭, 🖤, 🔪, 🧛, 🪦, 😱, 🙀, 🌕, ⚰️
-- jungle - 🦜 🦍 🌴 🐅 🐍 🌺 🦎
-- leaves - 🍂 🍁 🍀 🌿   
-- lunar - 🌑, 🌒, 🌓, 🌔, 🌕, 🌖, 🌗, 🌘
-- magical - 🔮 🌟 🧹 🎩 🐇 🪄 💫
-- mathematical - ➕, ➖, ✖️, ➗, ≠, ≈, ∞
-- matrix - ｦ, ｧ, ｨ, ｩ, ｪ, ｫ, ｬ, ｭ, ｮ, ｯ, ｰ, ｱ, ｲ, ｳ, ｴ, ｵ, ｶ, ｷ, ｸ, ｹ, ｺ, ｻ, ｼ, ｽ, ｾ, ｿ, ﾀ, ﾁ, ﾂ, ﾃ, ﾄ, ﾅ, ﾆ, ﾇ, ﾈ, ﾉ, ﾊ, ﾋ, ﾌ, ﾍ, ﾎ, ﾏ, ﾐ, ﾑ, ﾒ, ﾓ, ﾔ, ﾕ, ﾖ, ﾗ, ﾘ, ﾙ, ﾚ, ﾛ, ﾜ, ﾝ, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, -, =, *, _, +, |, :, <, >, "
-- medieval - 🏰 🛡️ ⚔️ 🎠 👑 🏹 🍺
-- musical - 🎵 🎶 🎤 🎷 🎸 🎺 🎻
-- mystery - 🕵️, 🔎, 🔒, 🔑, 📜, 🖋️, 🗝️
-- mystical - 🔮 🌕 🌟 📜 ✨ 🔥 💫
-- new_year - 🎆 🎉 🍾 🥂 ⏰ 🕛 🎈 🌟 ✨ 🎊 🥳 💫 📅 2️⃣ 0️⃣ 2️⃣ 4️⃣
-- nocturnal - 🦉 🌙 🦇 🌌 🌠 🔭 🌚
-- ocean - 🌊 🐠 🐟 🐡 🐬 🐳 🦈 🐚 ⛵
-- pirate - ☠️ ⚓ 🏴‍☠️ 🗺️ 🦜 ⚔️ 💰
-- retro - 📻 📺 🎞️ 📼 🎙️ 🕰️ ☎️
-- snow - ❄️  ❅ ❇ * .
-- spa - 🕯️ 🛁 🌸 💆 🍵 🧘 💅
-- space - 🪐 🌌 ⭐ 🌙 🚀 🛰️ ☄️ 🌠 👩‍🚀
-- sports - ⚽ 🏀 🏈 ⚾ 🎾 🏓 🏒
-- spring - 🐑 🐇 🦔 🐣 🦢 🐝 🌻 🌼 🌷 🌱 🌳 🌾 🍀 🍃 🌈
-- stars - ★ ⭐ ✮ ✦ ✬ ✯ 🌟
-- steampunk - ⚙️ 🕰️ 🎩 🚂 🧭 🔭 🗝️
-- st_patricks_day - 🍀 🌈 💚 🇮🇪 🎩 🥔 🍺 🍻 🥃 🍖 💰 🌟 🍵 🐍 🪄
-- summer - 😎 🏄 🏊 🌻 🌴 🍹 🏝️ ☀️ 🌞 🕶️ 👕 ⛵ 🥥 🌊
-- temporal - 🕐, 🕑, 🕒, 🕓, 🕔, 🕕, 🕖, 🕗, 🕘, 🕙, 🕚, 🕛
-- thanksgiving - 🦃 🍂 🍁 🌽 🥧 🍠 🍎 🍖 🍗 🥖 🥔 🍇 🍷 🌰 🥕
-- travel - ✈️, 🌍, 🗺️, 🏨, 🧳, 🗽, 🚂
-- tropical - 🌴 🍍 🍉 🥥 🌺 🐢 🌊
-- urban - 🏢 🚕 🚇 🍕 🚦 🛴 🎧
-- us_independence_day - 🇺🇸 🎆 🗽 🦅 🌭 🍔 ⭐ 🎉 🥳 🍻 🥁 🎵 🎶 🚀 💥v
-- valentines_day - ❤️ 💖 💘 💝 💕 💓 💞 💟 💌 🌹 🍫 💐 💍 🍷 🕯️
-- wilderness - 🌲 🐺 🦌 🏞️ 🔥 ⛺ 🌌
-- wildwest - 🤠 🐎 🌵 🔫 ⛏️ 🌄 🚂
-- winter_wonderland - ❄️ ⛄ 🌨️ 🎿 🛷 🏔️ 🧣
-- xmas - 🎄 🎁 🤶 🎅 🛷 ❄ ⛄ 🌟 🦌 🎶 ❄️  ❅ ❇ *
-- zodiac - ♈, ♉, ♊, ♋, ♌, ♍, ♎, ♏, ♐, ♑, ♒, ♓
-- zoo - 🦁 🐘 🦓 🦒 🦅 🦉 🐆
