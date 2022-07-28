Config = {}
Config.BallObject = `prop_bowling_ball`
-- Config.BallObject = `denis3d_bowling_ball_01`
Config.StandAnimDict = 'weapons@projectile@'
Config.StandAnim = 'aimlive_l'
Config.ThrowAnim = 'throw_l_fb_stand'
Config.MaxAngleMovement = 25
Config.BaseBallForce = 5

Config.PinObject = `prop_bowling_pin`
Config.PinList = {}

Config.DisplayDirectionalLine = false
Config.DisplayForceBar = true
Config.DirectionChangeSpeed = 0.20

Config.BowlingLanes = {
    [1] = {
        enabled = true,
        pos = vector3(748.0, -781.93, 26.45),
        pins = vector4(729.62, -782.32, 25.45, 277.96)
    },
    [2] = {
        enabled = true,
        pos = vector3(747.93, -779.73, 26.45),
        pins = vector4(729.62, -780.15, 25.45, 277.96)
    },
    [3] = {
        enabled = true,
        pos = vector3(747.9, -777.67, 26.45),
        pins = vector4(729.62, -778.05, 25.45, 277.96)
    },
    [4] = {
        enabled = true,
        pos = vector3(747.87, -775.59, 26.45),
        pins = vector4(729.62, -775.98, 25.45, 277.96)
    },
    [5] = {
        enabled = true,
        pos = vector3(747.92, -773.53, 26.45),
        pins = vector4(729.62, -773.91, 25.45, 277.96)
    },
    [6] = {
        enabled = true,
        pos = vector3(747.89, -771.41, 26.45),
        pins = vector4(729.62, -771.89, 25.45, 277.96)
    },
    [7] = {
        enabled = false,
        pos = vector3(0,0,0),
        pins = vector4(0,0,0,0)
    },
    [8] = {
        enabled = true,
        pos = vector3(747.91, -767.16, 26.45),
        pins = vector4(729.44, -767.64, 25.45, 277.96)
    }
}

Config.BowlingVendor = {
    ['bowlingball'] = {
      name = 'Bowling Ball',
      price = 50
    },
    ['bowlingreceipt'] = {
      name = 'Lane Access',
      price = 25
    }
}