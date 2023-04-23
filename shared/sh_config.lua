Config = {}

-- % Chance to Find Items ( Out of 100% ) --
Config.ItemChance = 10

-- Min / Max Amount of Money Found (In Cents) --
Config.Money = {
    min = 100,
    max = 1000
}

-- Find Items on Bodies --
Config.Items = {
    [1] = {
        {
            item = 'bread',
            amount = 1
        },
        {
            item = 'water',
            amount = 1
        }
    },
    [2] = {
        {
            item = 'ammo_revolver',
            amount = 1
        }
    },
}
