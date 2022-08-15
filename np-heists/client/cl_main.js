//file partially deobfuscated by Defcon#2974 - all strings decrypted, enjoy
const a0_0x420491 = (function () {
    let _0x241f19 = true
    return function (_0x49a3ee, _0x28eaf3) {
      const _0x5ab799 = _0x241f19
        ? function () {
            if (_0x28eaf3) {
              const _0x11ed19 = _0x28eaf3.apply(_0x49a3ee, arguments)
              return (_0x28eaf3 = null), _0x11ed19
            }
          }
        : function () {}
      return (_0x241f19 = false), _0x5ab799
    }
  })(),
  a0_0x213599 = a0_0x420491(this, function () {
    return a0_0x213599
      .toString()
      .search('(((.+)+)+)+$')
      .toString()
      .constructor(a0_0x213599)
      .search('(((.+)+)+)+$')
  })
a0_0x213599()
;(() => {
  'use strict'
  var _0x2e9b37 = {
    g: (function () {
      if (typeof globalThis === 'object') {
        return globalThis
      }
      try {
        return this || new Function('return this')()
      } catch (_0xc27877) {
        if (typeof window === 'object') {
          return window
        }
      }
    })(),
  }
  ;(() => {})()
  var _0x3e9046 = {}
  let _0x4cff6f = exports['np-config'].GetModuleConfig('main')
  const _0x3fbe85 = new Map(),
    _0x4fd533 = GetCurrentResourceName()
  async function _0x4cb156() {}
  on('np-config:configLoaded', (_0x24343a, _0x52e410) => {
    if (_0x24343a === 'main') {
      _0x4cff6f = _0x52e410
    } else {
      _0x3fbe85.has(_0x24343a) && _0x3fbe85.set(_0x24343a, _0x52e410)
    }
  })
  function _0xe946f0(_0x5d5ef0) {
    return _0x4cff6f[_0x5d5ef0]
  }
  function _0x2f22a1(_0x402b9b, _0x1f95c8) {
    if (!_0x3fbe85.has(_0x402b9b)) {
      const _0x1c8247 = exports['np-config'].GetModuleConfig(_0x402b9b)
      if (_0x1c8247 === undefined) {
        return
      }
      _0x3fbe85.set(_0x402b9b, _0x1c8247)
    }
    const _0x356ec2 = _0x3fbe85.get(_0x402b9b)
    return _0x1f95c8
      ? _0x356ec2 === null || _0x356ec2 === void 0
        ? void 0
        : _0x356ec2[_0x1f95c8]
      : _0x356ec2
  }
  function _0x109f88(_0x1d25fa) {
    return _0x2f22a1(_0x4fd533, _0x1d25fa)
  }
  const _0x1196d1 = globalThis.NPX,
    _0x11a92c = _0x1196d1.Hud,
    _0x5ae501 = _0x1196d1.Utils,
    _0x399ff7 = _0x1196d1.Zones,
    _0x288d26 = _0x1196d1.Events,
    _0x54cae9 = _0x1196d1.Streaming,
    _0x349e09 = _0x1196d1.Procedures,
    _0x1a26f0 = _0x1196d1.Interface,
    _0x2bb0d2 = null && _0x1196d1
  const _0x47900a = globalThis
  async function _0x4547b9(_0x4507c7) {
    return new Promise((_0x53c16c) => setTimeout(() => _0x53c16c(), _0x4507c7))
  }
  const _0x989475 = 'laptop',
    _0x39a9ca = 'np-ui:heistsPanelMinigameResult'
  let _0x306b83,
    _0x19e93a = 1
  const _0x28bca6 = async (_0x3d0f33) => {
    var _0x185a68
    _0x306b83 = null
    const _0x35519a = !!_0x3d0f33.gameFinishedEndpoint
    _0x3d0f33.gameDuration *= _0x19e93a
    ;(_0x185a68 = _0x3d0f33.gameFinishedEndpoint) !== null &&
    _0x185a68 !== void 0
      ? _0x185a68
      : (_0x3d0f33.gameFinishedEndpoint = _0x39a9ca)
    _0x2e9b37.g.exports['np-ui'].openApplication(
      'minigame-captcha-evolved',
      _0x3d0f33
    )
    if (_0x35519a) {
      return
    }
    const _0x15b57f = await _0x5ae501.waitForCondition(() => {
      return _0x306b83 !== undefined && _0x306b83 !== null
    }, 300000)
    if (_0x15b57f) {
      return false
    }
    return (
      _0x306b83 &&
        _0x3d0f33.minigameHackExp &&
        emitNet('np-heists:hack:success', _0x3d0f33.minigameHackExp),
      emitNet('np-heists:hack:track', _0x306b83, 'laptop'),
      _0x306b83
    )
  }
  RegisterUICallback(_0x39a9ca, async (_0x1f1f25, _0x246562) => {
    _0x306b83 = _0x1f1f25.success
    const _0x5a3645 = {
      ok: true,
      message: '',
    }
    const _0x8510c7 = {}
    return (
      (_0x8510c7.data = 'success'),
      (_0x8510c7.meta = _0x5a3645),
      _0x246562(_0x8510c7)
    )
  })
  _0x2e9b37.g.exports('panelMultiplier', (_0x3ca855) => {
    _0x19e93a = Math.min(_0x3ca855, 1.15)
  })
  _0x2e9b37.g.exports('BankMinigame', _0x28bca6)
  const _0x38020f = 'keyboard',
    _0x33e005 = 'np-ui:heistsDDRMinigameResult'
  let _0x39495d
  const _0xd70562 = async (_0x5a7e54) => {
    var _0x5912d6
    _0x39495d = null
    const _0x22378a = !!_0x5a7e54.gameFinishedEndpoint
    ;(_0x5912d6 = _0x5a7e54.gameFinishedEndpoint) !== null &&
    _0x5912d6 !== void 0
      ? _0x5912d6
      : (_0x5a7e54.gameFinishedEndpoint = _0x33e005)
    exports['np-ui'].openApplication('minigame-ddr', _0x5a7e54)
    if (_0x22378a) {
      return
    }
    const _0x27adff = await _0x5ae501.waitForCondition(() => {
      return _0x39495d !== undefined && _0x39495d !== null
    }, 120000)
    if (_0x27adff) {
      return false
    }
    return emitNet('np-heists:hack:track', _0x39495d, 'ddr'), _0x39495d
  }
  RegisterUICallback(_0x33e005, async (_0xb37dbe, _0x605788) => {
    _0x39495d = _0xb37dbe.success
    const _0x5294fb = {
      ok: true,
      message: '',
    }
    const _0xdfc8bc = {}
    return (
      (_0xdfc8bc.data = 'success'),
      (_0xdfc8bc.meta = _0x5294fb),
      _0x605788(_0xdfc8bc)
    )
  })
  on('np-ui:application-closed', async (_0x1f7549) => {
    if (_0x1f7549 !== 'minigame-ddr') {
      return
    }
    ;(_0x39495d === undefined || _0x39495d === null) && (_0x39495d = false)
  })
  _0x2e9b37.g.exports('DDRMinigame', _0xd70562)
  const _0x20d9f8 = 'np-ui:heistsUntangleMinigameResult'
  let _0x2527b0
  const _0x1fae28 = async (_0x354369) => {
    var _0x17afd4
    _0x2527b0 = null
    const _0x5d41ea = !!_0x354369.gameFinishedEndpoint
    ;(_0x17afd4 = _0x354369.gameFinishedEndpoint) !== null &&
    _0x17afd4 !== void 0
      ? _0x17afd4
      : (_0x354369.gameFinishedEndpoint = _0x20d9f8)
    exports['np-ui'].openApplication('minigame-flip', _0x354369)
    if (_0x5d41ea) {
      return
    }
    const _0x1c995f = await _0x5ae501.waitForCondition(() => {
      return _0x2527b0 !== undefined && _0x2527b0 !== null
    }, 60000)
    if (_0x1c995f) {
      return false
    }
    return emitNet('np-heists:hack:track', _0x2527b0, 'flip'), _0x2527b0
  }
  RegisterUICallback(_0x20d9f8, async (_0x33d23d, _0x1d76c2) => {
    _0x2527b0 = _0x33d23d.success
    const _0x233214 = {
      ok: true,
      message: '',
    }
    const _0xebd890 = {}
    return (
      (_0xebd890.data = 'success'),
      (_0xebd890.meta = _0x233214),
      _0x1d76c2(_0xebd890)
    )
  })
  on('np-ui:application-closed', async (_0x1fdf11) => {
    if (_0x1fdf11 !== 'minigame-untangle') {
      return
    }
    ;(_0x2527b0 === undefined || _0x2527b0 === null) && (_0x2527b0 = false)
  })
  _0x2e9b37.g.exports('FlipMinigame', _0x1fae28)
  const _0x58d72f = 'project-diagram',
    _0x482487 = 'np-ui:heistsUntangleMinigameResult'
  let _0x36ea28
  const _0x562cba = async (_0x489db3) => {
    var _0x5c9fc1
    _0x36ea28 = null
    const _0x47f96f = !!_0x489db3.gameFinishedEndpoint
    ;(_0x5c9fc1 = _0x489db3.gameFinishedEndpoint) !== null &&
    _0x5c9fc1 !== void 0
      ? _0x5c9fc1
      : (_0x489db3.gameFinishedEndpoint = _0x482487)
    exports['np-ui'].openApplication('minigame-untangle', _0x489db3)
    if (_0x47f96f) {
      return
    }
    const _0x1a6890 = await _0x5ae501.waitForCondition(() => {
      return _0x36ea28 !== undefined && _0x36ea28 !== null
    }, 60000)
    if (_0x1a6890) {
      return false
    }
    return emitNet('np-heists:hack:track', _0x36ea28, 'untangle'), _0x36ea28
  }
  RegisterUICallback(_0x482487, async (_0x4f37f9, _0x5d7f6d) => {
    _0x36ea28 = _0x4f37f9.success
    const _0x5c5a31 = {
      ok: true,
      message: '',
    }
    const _0x9488d7 = {}
    return (
      (_0x9488d7.data = 'success'),
      (_0x9488d7.meta = _0x5c5a31),
      _0x5d7f6d(_0x9488d7)
    )
  })
  on('np-ui:application-closed', async (_0x4f0144) => {
    if (_0x4f0144 !== 'minigame-untangle') {
      return
    }
    if (_0x36ea28 === undefined || _0x36ea28 === null) {
      _0x36ea28 = false
    }
  })
  _0x2e9b37.g.exports('UntangleMinigame', _0x562cba)
  const _0xb0535 = [
      'Int01_ba_security_upgrade',
      'Int01_ba_equipment_setup',
      'DJ_01_Lights_02',
      'Int01_ba_style02_podium',
      'int01_ba_lights_screen',
      'Int01_ba_Screen',
      'Int01_ba_bar_content',
      'Int01_ba_booze_01',
      'Int01_ba_booze_02',
      'Int01_ba_booze_03',
      'Int01_ba_dj01',
      'Int01_ba_Clutter',
      'Int01_ba_clubname_01',
      'Int01_ba_dry_ice',
      'Int01_ba_deliverytruck',
    ],
    _0x3b6b93 = null && [
      'SE_BA_DLC_INT_01_BOGS',
      'SE_BA_DLC_INT_01_ENTRY_HALL',
      'SE_BA_DLC_INT_01_ENTRY_STAIRS',
      'SE_BA_DLC_INT_01_GARAGE',
      'SE_BA_DLC_INT_01_MAIN_AREA_2',
      'SE_BA_DLC_INT_01_MAIN_AREA',
      'SE_BA_DLC_INT_01_OFFICE',
      'SE_BA_DLC_INT_01_REAR_L_CORRIDOR',
    ]
  let _0x240175 = 0,
    _0x37cffe = 1,
    _0x3bbc99 = ''
  onNet('np-jobmanager:playerBecameJob', (_0x49455c) => {
    _0x3bbc99 = _0x49455c
  })
  const _0x5432d6 = async () => {
    _0x240175 = GetInteriorAtCoordsWithType(
      -1604.664,
      -3012.583,
      -79.9999,
      'ba_dlc_int_01_ba'
    )
    const _0x1d86af = {
      x: 52.77,
      y: 160.8,
      z: 103.73,
    }
    const _0x3470eb = {
      heading: 70,
      minZ: 103.73,
      maxZ: 107.23,
    }
    _0x399ff7.addBoxZone(
      '1',
      'heist_club_entrance',
      _0x1d86af,
      2.4,
      3.2,
      _0x3470eb
    )
    const _0x213f99 = {
      x: -1618.78,
      y: -2999.4,
      z: -79.15,
    }
    const _0x455994 = {
      heading: 180,
      minZ: -79.15,
      maxZ: -76.15,
    }
    _0x399ff7.addBoxZone('1', 'heist_club_exit', _0x213f99, 0.8, 2.1, _0x455994)
    const _0x34451b = {
      x: -1620.05,
      y: -3010.49,
      z: -75.51,
    }
    const _0x304d3e = {
      heading: 41,
      minZ: -75.51,
      maxZ: -75.01,
    }
    _0x399ff7.addBoxTarget('1', 'heist_club_pc', _0x34451b, 0.7, 0.9, _0x304d3e)
    const _0x10caa2 = {
      id: 'heist_club_entrance',
      label: 'Elevator',
      icon: 'sort',
      NPXEvent: 'np-heists:club:elevator',
    }
    const _0x581e96 = { radius: 2 }
    const _0x4c7a38 = {
      distance: _0x581e96,
      isEnabled: () => _0x3bbc99 !== 'police',
    }
    _0x1a26f0.addPeekEntryByTarget(
      'heist_club_entrance',
      [_0x10caa2],
      _0x4c7a38
    )
    const _0xbd97b1 = { exit: true }
    const _0x31e123 = {
      id: 'heist_club_exit',
      label: 'Exit',
      icon: 'sort-up',
      NPXEvent: 'np-heists:club:elevator',
      parameters: _0xbd97b1,
    }
    const _0x44975b = { radius: 2 }
    const _0x3b34ae = {
      distance: _0x44975b,
      isEnabled: () => true,
    }
    _0x1a26f0.addPeekEntryByTarget('heist_club_exit', [_0x31e123], _0x3b34ae)
    const _0x12dbd0 = {
      id: 'heist_club_ceo',
      label: 'talk',
      icon: 'comment',
      NPXEvent: 'np-heists:club:talk:ceo',
      parameters: {},
    }
    const _0x2bd472 = { radius: 2.5 }
    const _0x31da5f = {
      npcIds: ['npc_hc_1'],
      distance: _0x2bd472,
      isEnabled: () => true,
    }
    _0x1a26f0.addPeekEntryByFlag(['isNPC'], [_0x12dbd0], _0x31da5f)
    const _0x1370e7 = {
      id: 'heist_club_loot',
      label: 'turn in loot',
      icon: 'donate',
      NPXEvent: 'np-heists:club:talk:loot',
      parameters: {},
    }
    const _0x364f75 = { radius: 2.5 }
    const _0x1a429d = {
      npcIds: ['npc_hc_4'],
      distance: _0x364f75,
      isEnabled: () => true,
    }
    _0x1a26f0.addPeekEntryByFlag(['isNPC'], [_0x1370e7], _0x1a429d)
    const _0x53f9d9 = {
      id: 'heist_club_pc',
      label: 'Trade in USBs',
      icon: 'plug',
      NPXEvent: 'np-heists:club:pc',
      parameters: {},
    }
    const _0x21324d = { radius: 2 }
    _0x1a26f0.addPeekEntryByTarget('heist_club_pc', [_0x53f9d9], {
      distance: _0x21324d,
      isEnabled: () => {
        const _0x485738 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistloot_usb',
          1,
          false,
          true
        )
        return _0x485738
      },
    })
  }
  _0x288d26.on('np-heists:club:talk:ceo', () => {
    const _0x1c4661 = [_0x55c370]
    if (_0x37cffe > 0) {
      const _0x1a8ac7 = {
        item_id: 'heistdecrypter_grey',
        cost: 2,
      }
      const _0x1287c5 = {
        icon: _0x58d72f,
        title: 'Basic Decrypter',
        titleRight: '\u25A8 2',
        action: 'np-heists:club:purchase',
        key: _0x1a8ac7,
      }
      _0x1c4661.push(_0x1287c5)
      const _0x2476a7 = {
        item_id: 'heistdrill_grey',
        cost: 5,
      }
      const _0x47029d = {
        icon: 'th',
        title: 'Basic Drill',
        titleRight: '\u25A8 5',
        action: 'np-heists:club:purchase',
        key: _0x2476a7,
      }
      _0x1c4661.push(_0x47029d)
      const _0x159116 = {
        item_id: 'heistlaptop3',
        cost: 8,
      }
      const _0x426324 = {
        icon: _0x989475,
        title: 'Green Laptop',
        titleRight: '\u25A8 8',
        action: 'np-heists:club:purchase',
        key: _0x159116,
      }
      _0x1c4661.push(_0x426324)
    }
    if (_0x37cffe > 1) {
      const _0x127c3c = {
        item_id: 'heistdecrypter_blue',
        cost: 10,
      }
      const _0x2fbf29 = {
        icon: _0x58d72f,
        title: 'Advanced Decrypter',
        titleRight: '\u25A8 10',
        action: 'np-heists:club:purchase',
        key: _0x127c3c,
      }
      _0x1c4661.push(_0x2fbf29)
      const _0x91b47c = {
        item_id: 'heistdrill_blue',
        cost: 25,
      }
      const _0x34164e = {
        icon: 'th',
        title: 'Advanced Drill',
        titleRight: '\u25A8 25',
        action: 'np-heists:club:purchase',
        key: _0x91b47c,
      }
      _0x1c4661.push(_0x34164e)
      const _0xf1ee3 = {
        item_id: 'heistelectronickit_blue',
        cost: 10,
      }
      const _0x1bffd9 = {
        icon: _0x38020f,
        title: 'Advanced Electronic Kit',
        titleRight: '\u25A8 10',
        action: 'np-heists:club:purchase',
        key: _0xf1ee3,
      }
      _0x1c4661.push(_0x1bffd9)
      const _0xc6de72 = {
        item_id: 'heistlaptop2',
        cost: 40,
      }
      const _0x2f4cf0 = {
        icon: _0x989475,
        title: 'Blue Laptop',
        titleRight: '\u25A8 40',
        action: 'np-heists:club:purchase',
        key: _0xc6de72,
      }
      _0x1c4661.push(_0x2f4cf0)
    }
    if (_0x37cffe > 2) {
      const _0x129ae4 = {
        item_id: 'heistdecrypter_red',
        cost: 50,
      }
      const _0x4c7473 = {
        icon: _0x58d72f,
        title: 'Hardened Decrypter',
        titleRight: '\u25A8 50',
        action: 'np-heists:club:purchase',
        key: _0x129ae4,
      }
      _0x1c4661.push(_0x4c7473)
      const _0x57b285 = {
        item_id: 'heistdrill_red',
        cost: 50,
      }
      const _0xd341a7 = {
        icon: 'th',
        title: 'Hardened Drill',
        titleRight: '\u25A8 20',
        action: 'np-heists:club:purchase',
        key: _0x57b285,
      }
      _0x1c4661.push(_0xd341a7)
      const _0x4efe74 = {
        item_id: 'heistelectronickit_red',
        cost: 20,
      }
      const _0x16f64a = {
        icon: _0x38020f,
        title: 'Hardened Electronic Kit',
        titleRight: '\u25A8 20',
        action: 'np-heists:club:purchase',
        key: _0x4efe74,
      }
      _0x1c4661.push(_0x16f64a)
      const _0x24af90 = {
        item_id: 'jammingdevice',
        cost: 15,
      }
      const _0x3b2fc4 = {
        icon: 'broadcast-tower',
        title: 'Jamming Device',
        titleRight: '\u25A8 15',
        action: 'np-heists:club:purchase',
        key: _0x24af90,
      }
      _0x1c4661.push(_0x3b2fc4)
      const _0x30fd40 = {
        item_id: 'heistlaptop4',
        cost: 200,
      }
      const _0x2a3fa5 = {
        icon: _0x989475,
        title: 'Red Laptop',
        titleRight: '\u25A8 32',
        action: 'np-heists:club:purchase',
        key: _0x30fd40,
      }
      _0x1c4661.push(_0x2a3fa5)
    }
    _0x2e9b37.g.exports['np-ui'].showContextMenu(_0x1c4661)
  })
  _0x288d26.on('np-heists:club:talk:loot', async () => {
    const _0x1205eb = await _0x349e09.execute('np-heists:club:loot')
  })
  _0x288d26.on('np-heists:club:pc', async () => {
    const _0x4cfa81 = await _0x349e09.execute('np-heists:club:pc')
  })
  _0x288d26.on(
    'np-heists:club:elevator',
    async (_0x41484a, _0x2c725f, _0x515639) => {
      if (_0x41484a.exit) {
        DoScreenFadeOut(500)
        await _0x4547b9(500)
        const _0x126afc = await _0x349e09.execute('np-heists:club:exit')
        if (_0x126afc) {
          SetEntityCoords(
            PlayerPedId(),
            53.45,
            160.57,
            104.71,
            false,
            false,
            false,
            false
          )
          SetEntityHeading(PlayerPedId(), 250)
        }
        await _0x4547b9(500)
        DoScreenFadeIn(500)
        _0x1858b9()
        return
      }
      const _0xc6dbf4 = await _0x23eaf9(),
        _0x459150 = {
          title: 'Level 1',
          action: 'np-heists:club:useElevator',
          disabled: _0xc6dbf4 < 1,
          key: 1,
        }
      const _0x42eff6 = {
        title: 'Level 2',
        action: 'np-heists:club:useElevator',
        disabled: _0xc6dbf4 < 2,
        key: 2,
      }
      const _0xae2724 = {
        title: 'Level 3',
        action: 'np-heists:club:useElevator',
        disabled: _0xc6dbf4 < 3,
        key: 3,
      }
      const _0x482db9 = {
        title: 'Level 4',
        action: 'np-heists:club:useElevator',
        disabled: _0xc6dbf4 < 4,
        key: 4,
      }
      const _0x2ab113 = [_0x459150, _0x42eff6, _0xae2724, _0x482db9]
      _0x2e9b37.g.exports['np-ui'].showContextMenu(_0x2ab113)
    }
  )
  RegisterUICallback(
    'np-heists:club:useElevator',
    async (_0x3b67f3, _0x20fa93) => {
      const _0x4c5988 = _0x3b67f3.key,
        _0x3b4b18 = await _0x23eaf9()
      if (_0x3b4b18 < _0x4c5988) {
        return
      }
      const _0x558457 = await _0x1a26f0.taskBar(
        3000,
        'Waiting for elevator...',
        true,
        {
          distance: 1,
          entity: PlayerPedId(),
        }
      )
      if (_0x558457 !== 100) {
        return
      }
      DoScreenFadeOut(500)
      await _0x4547b9(500)
      const _0x3ae6f7 = await _0x349e09.execute(
        'np-heists:club:useElevator',
        _0x4c5988
      )
      _0x3ae6f7 &&
        (SetEntityCoords(
          PlayerPedId(),
          -1618.59,
          -2998.53,
          -78.14,
          false,
          false,
          false,
          false
        ),
        SetEntityHeading(PlayerPedId(), 0),
        _0x5046ce(_0x4c5988))
      await _0x4547b9(500)
      DoScreenFadeIn(500)
      const _0x58d783 = {
        ok: true,
        message: '',
      }
      const _0x556ced = {}
      return (
        (_0x556ced.data = 'success'),
        (_0x556ced.meta = _0x58d783),
        _0x20fa93(_0x556ced)
      )
    }
  )
  RegisterUICallback(
    'np-heists:club:purchase',
    async (_0x447f05, _0x2fcece) => {
      const _0x2e74e4 = {
        ok: true,
        message: '',
      }
      const _0x1decd8 = {
        data: 'success',
        meta: _0x2e74e4,
      }
      _0x2fcece(_0x1decd8)
      const _0xcc936e = _0x349e09.execute(
        'np-heists:club:purchase',
        _0x447f05.key
      )
    }
  )
  const _0x5046ce = async (_0xa9e689) => {
      for (const _0x556816 of _0xb0535) {
        !IsInteriorPropEnabled(_0x240175, _0x556816) &&
          EnableInteriorProp(_0x240175, _0x556816)
      }
      DisableInteriorProp(_0x240175, 'Int01_ba_Style01')
      DisableInteriorProp(_0x240175, 'Int01_ba_Style02')
      DisableInteriorProp(_0x240175, 'Int01_ba_Style03')
      EnableInteriorProp(_0x240175, 'Int01_ba_Style0' + _0xa9e689)
      _0x37cffe = _0xa9e689
      RequestScriptAudioBank('DLC_BATTLE/BTL_CLUB_OPEN_TRANSITION_CROWD', false)
      SetAmbientZoneState('IZ_ba_dlc_int_01_ba_Int_01_main_area', false, false)
      await _0x4547b9(100)
      RefreshInterior(_0x240175)
      await _0x4547b9(100)
      StartAudioScene('DLC_Ba_NightClub_Scene')
    },
    _0x1858b9 = async () => {
      IsAudioSceneActive('DLC_Ba_NightClub_Scene') &&
        StopAudioScene('DLC_Ba_NightClub_Scene')
      SetAmbientZoneState('IZ_ba_dlc_int_01_ba_Int_01_main_area', true, true)
      ReleaseScriptAudioBank()
    },
    _0x58062d = {
      cb: 2,
      cg: 2,
      gg: 2,
      st: 2,
      mandem: 2,
      rust: 2,
      seaside: 2,
      angels: 1,
      bbmc: 1,
      hoa: 1,
      hydra: 1,
      lostmc: 1,
      nbc: 1,
    }
  const _0x388455 = _0x58062d,
    _0x23eaf9 = async () => {
      var _0xda664
      const _0x3128ac = _0x2e9b37.g.exports['np-config'].GetMiscConfig(
          'heists.access.whitelisted'
        ),
        _0x5f1a8c = await _0x587760.get()
      if (_0x3128ac) {
        return (_0xda664 = _0x388455[_0x5f1a8c]) !== null && _0xda664 !== void 0
          ? _0xda664
          : 1
      }
      const _0x466138 = _0x2e9b37.g.exports['np-config'].GetMiscConfig(
        'heists.access.level'
      )
      return _0x466138 !== null && _0x466138 !== void 0 ? _0x466138 : 1
    },
    _0x3c5aa0 = { timeToLive: 900000 }
  const _0x587760 = _0x5ae501.cache(async (_0x37c569) => {
    const _0x461985 = await _0x349e09.execute('np-gangsystem:getCurrentGang')
    return [true, _0x461985]
  }, _0x3c5aa0)
  _0x2e9b37.g.exports('GetHeistLevel', _0x23eaf9)
  class _0x5a531b {
    constructor(_0x6589cc, _0x1cd74b, _0x126bd5 = 'interval') {
      this.callback = _0x6589cc
      this.delay = _0x1cd74b
      this.mode = _0x126bd5
      this.scheduled = {}
      this.tick = 0
      this.data = {}
      this.hooks = new Map([
        ['active', []],
        ['preStop', []],
        ['preStart', []],
        ['afterStop', []],
        ['afterStart', []],
        ['stopAborted', []],
        ['startAborted', []],
      ])
    }
    get ['isActive']() {
      return this.active
    }
    async ['start']() {
      if (this.active) {
        return
      }
      this.aborted = false
      this.scheduled = {}
      const _0x414875 = this.hooks.get('preStart')
      try {
        for (const _0x319445 of _0x414875) {
          if (!this.aborted) {
            await _0x319445.call(this)
          }
        }
      } catch (_0x363988) {
        this.aborted = true
        console.log('Error while calling pre-start hook', _0x363988.message)
      }
      if (this.aborted) {
        try {
          const _0x222af1 = this.hooks.get('startAborted')
          for (const _0x45ba7b of _0x222af1) {
            await _0x45ba7b.call(this)
          }
        } catch (_0x1b7585) {
          console.log(
            'Error while calling start-aborted hook',
            _0x1b7585.message
          )
        }
        return
      }
      this.active = true
      const _0x529482 = this.hooks.get('active')
      switch (this.mode) {
        case 'tick': {
          this.threadId = _0x47900a.setTick(async () => {
            this.tick += 1
            try {
              await this.callback.call(this)
              for (const _0x4c5fc8 of _0x529482) {
                await _0x4c5fc8.call(this)
              }
            } catch (_0x2c4175) {
              console.log('Error while calling active hook', _0x2c4175.message)
            }
            this.delay > 0 &&
              (await new Promise((_0x4bb769) =>
                _0x47900a.setTimeout(_0x4bb769, this.delay)
              ))
          })
          break
        }
        case 'interval': {
          this.threadId = _0x47900a.setInterval(async () => {
            this.tick += 1
            try {
              await this.callback.call(this)
              for (const _0x5d1004 of _0x529482) {
                await _0x5d1004.call(this)
              }
            } catch (_0x5800c8) {
              console.log('Error while calling active hook', _0x5800c8.message)
            }
          }, this.delay)
          break
        }
        case 'timeout': {
          const _0x1f2602 = () => {
            this.active &&
              (this.threadId = _0x47900a.setTimeout(async () => {
                this.tick += 1
                try {
                  await this.callback.call(this)
                  for (const _0x1aa7d4 of _0x529482) {
                    await _0x1aa7d4.call(this)
                  }
                } catch (_0x2f4a92) {
                  console.log(
                    'Error while calling active hook',
                    _0x2f4a92.message
                  )
                }
                return _0x1f2602()
              }, this.delay))
          }
          _0x1f2602()
          break
        }
      }
      const _0x295b6c = this.hooks.get('afterStart')
      try {
        for (const _0x5ea1f5 of _0x295b6c) {
          await _0x5ea1f5.call(this)
        }
      } catch (_0x3a7f6a) {
        console.log('Error while calling after-start hook', _0x3a7f6a.message)
      }
    }
    async ['stop']() {
      if (!this.active) {
        return
      }
      const _0xb66bf = this.hooks.get('preStop')
      try {
        for (const _0x492f92 of _0xb66bf) {
          if (!this.aborted) {
            await _0x492f92.call(this)
          }
        }
      } catch (_0x2563bb) {
        this.aborted = true
        console.log('Error while calling pre-stop hook', _0x2563bb.message)
      }
      this.active = false
      switch (this.mode) {
        case 'tick': {
          _0x47900a.clearTick(this.threadId)
          break
        }
        case 'interval': {
          _0x47900a.clearInterval(this.threadId)
          break
        }
        case 'timeout': {
          _0x47900a.clearTimeout(this.threadId)
          break
        }
      }
      if (this.aborted) {
        try {
          const _0x2c14a9 = this.hooks.get('stopAborted')
          for (const _0x504299 of _0x2c14a9) {
            await _0x504299.call(this)
          }
        } catch (_0x2da787) {
          console.log(
            'Error while calling stop-aborted hook',
            _0x2da787.message
          )
        }
        return
      }
      const _0x6ad3bd = this.hooks.get('afterStop')
      try {
        for (const _0x3a4821 of _0x6ad3bd) {
          await _0x3a4821.call(this)
        }
      } catch (_0x3f20dd) {
        console.log('Error while calling after-stop hook', _0x3f20dd.message)
      }
    }
    ['abort']() {
      this.aborted = true
    }
    ['addHook'](_0xb6efcb, _0x745810) {
      var _0x469292
      ;(_0x469292 = this.hooks.get(_0xb6efcb)) === null || _0x469292 === void 0
        ? void 0
        : _0x469292.push(_0x745810)
    }
    ['setNextTick'](_0x45a408, _0x5f4315) {
      this.scheduled[_0x45a408] = this.tick + _0x5f4315
    }
    ['canTick'](_0x2e17e8) {
      return (
        this.scheduled[_0x2e17e8] === undefined ||
        this.tick >= this.scheduled[_0x2e17e8]
      )
    }
  }
  class _0x124ede {
    constructor(_0x226aa5 = 0, _0x533aa3 = 0, _0x19df0c = 0) {
      this.x = _0x226aa5
      this.y = _0x533aa3
      this.z = _0x19df0c
    }
    ['setFromArray'](_0xc022ea) {
      return (
        (this.x = _0xc022ea[0]),
        (this.y = _0xc022ea[1]),
        (this.z = _0xc022ea[2]),
        this
      )
    }
    ['getArray']() {
      return [this.x, this.y, this.z]
    }
    ['add'](_0x37194d) {
      return (
        (this.x += _0x37194d.x),
        (this.y += _0x37194d.y),
        (this.z += _0x37194d.z),
        this
      )
    }
    ['addScalar'](_0x41da7d) {
      return (
        (this.x += _0x41da7d),
        (this.y += _0x41da7d),
        (this.z += _0x41da7d),
        this
      )
    }
    ['sub'](_0x176253) {
      return (
        (this.x -= _0x176253.x),
        (this.y -= _0x176253.y),
        (this.z -= _0x176253.z),
        this
      )
    }
    ['equals'](_0x43d32d) {
      return (
        this.x === _0x43d32d.x &&
        this.y === _0x43d32d.y &&
        this.z === _0x43d32d.z
      )
    }
    ['subScalar'](_0x4644e2) {
      return (
        (this.x -= _0x4644e2),
        (this.y -= _0x4644e2),
        (this.z -= _0x4644e2),
        this
      )
    }
    ['multiply'](_0x42166e) {
      return (
        (this.x *= _0x42166e.x),
        (this.y *= _0x42166e.y),
        (this.z *= _0x42166e.z),
        this
      )
    }
    ['multiplyScalar'](_0x1c7f10) {
      return (
        (this.x *= _0x1c7f10),
        (this.y *= _0x1c7f10),
        (this.z *= _0x1c7f10),
        this
      )
    }
    ['round']() {
      return (
        (this.x = Math.round(this.x)),
        (this.y = Math.round(this.y)),
        (this.z = Math.round(this.z)),
        this
      )
    }
    ['floor']() {
      return (
        (this.x = Math.floor(this.x)),
        (this.y = Math.floor(this.y)),
        (this.z = Math.floor(this.z)),
        this
      )
    }
    ['ceil']() {
      return (
        (this.x = Math.ceil(this.x)),
        (this.y = Math.ceil(this.y)),
        (this.z = Math.ceil(this.z)),
        this
      )
    }
    ['magnitude']() {
      return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z)
    }
    ['normalize']() {
      let _0x8afdac = this.magnitude()
      if (isNaN(_0x8afdac)) {
        _0x8afdac = 0
      }
      return this.multiplyScalar(1 / _0x8afdac)
    }
    ['forward']() {
      const _0x34cfc6 = _0x124ede.fromObject(this).multiplyScalar(Math.PI / 180)
      return new _0x124ede(
        -Math.sin(_0x34cfc6.z) * Math.abs(Math.cos(_0x34cfc6.x)),
        Math.cos(_0x34cfc6.z) * Math.abs(Math.cos(_0x34cfc6.x)),
        Math.sin(_0x34cfc6.x)
      )
    }
    ['cross'](_0x48fe91) {
      return new _0x124ede(
        this.y * _0x48fe91.z - this.z * _0x48fe91.y,
        this.z * _0x48fe91.x - this.x * _0x48fe91.z,
        this.x * _0x48fe91.y - this.y * _0x48fe91.x
      )
    }
    ['getDistance'](_0xb521c3) {
      const [_0x2743f6, _0xafa1b4, _0x5ee331] = [
        this.x - _0xb521c3.x,
        this.y - _0xb521c3.y,
        this.z - _0xb521c3.z,
      ]
      return Math.sqrt(
        _0x2743f6 * _0x2743f6 + _0xafa1b4 * _0xafa1b4 + _0x5ee331 * _0x5ee331
      )
    }
    ['getDistanceFromArray'](_0x169a78) {
      const [_0x35e9fe, _0x5a81fe, _0x2685a6] = [
        this.x - _0x169a78[0],
        this.y - _0x169a78[1],
        this.z - _0x169a78[2],
      ]
      return Math.sqrt(
        _0x35e9fe * _0x35e9fe + _0x5a81fe * _0x5a81fe + _0x2685a6 * _0x2685a6
      )
    }
    static ['fromArray'](_0x2486a2) {
      return new _0x124ede(_0x2486a2[0], _0x2486a2[1], _0x2486a2[2])
    }
    static ['fromObject'](_0x4d0e25) {
      return new _0x124ede(_0x4d0e25.x, _0x4d0e25.y, _0x4d0e25.z)
    }
  }
  const _0x3774b2 = {
    id: 'legion_square',
    coords: [146.71, -1045.68, 29.37],
    hash: 2121050683,
    headingClosed: 249.85,
    headingOpen: 151.85,
  }
  const _0x26eae7 = {
    id: 1,
    name: 'Legion Square',
    doorConf: _0x3774b2,
    panelCoords: [146.55, -1045.68, 29.37, 160],
    powerCoords: [138.49, -1056.33, 29.2],
    frontDoorId: 1068,
    vaultDoorId: 1069,
    innerDoorId: 89,
  }
  const _0x1c63e9 = {
    id: 'pink_cage',
    coords: [310.81, -284.02, 54.17],
    hash: 2121050683,
    headingClosed: 249.865,
    headingOpen: 151.865,
  }
  const _0x1c73cf = {
    id: 2,
    name: 'Pink Cage',
    doorConf: _0x1c63e9,
    panelCoords: [310.81, -284.02, 54.17, 160],
    powerCoords: [319.99, -316.01, 51.12],
    frontDoorId: 1070,
    vaultDoorId: 1071,
    innerDoorId: 512,
  }
  const _0x2cb721 = {
    id: 'hawick',
    coords: [-354.18, -54.9, 49.05],
    hash: 2121050683,
    headingClosed: 250.86,
    headingOpen: 152.86,
  }
  const _0x3ac86c = {
    id: 3,
    name: 'Hawick',
    doorConf: _0x2cb721,
    panelCoords: [-354.18, -54.9, 49.05, 160],
    powerCoords: [-356.42, -50.25, 54.43],
    frontDoorId: 1072,
    vaultDoorId: 1073,
    innerDoorId: 513,
  }
  const _0x176984 = {
    id: 'life_invader',
    coords: [-1211.2, -336.62, 37.79],
    hash: 2121050683,
    headingClosed: 296.86,
    headingOpen: 198.86,
  }
  const _0x19ebd8 = {
    id: 4,
    name: 'LifeInvader',
    doorConf: _0x176984,
    panelCoords: [-1211.4, -336.52, 37.79, 205],
    powerCoords: [-1216.92, -332.87, 42.13],
    frontDoorId: 1074,
    vaultDoorId: 1075,
    innerDoorId: 514,
  }
  const _0x7ec33b = {
    id: 'great_ocean',
    coords: [-2956.77, 481.33, 15.7],
    hash: 2121050683,
    headingClosed: 357.542,
    headingOpen: 259.542,
  }
  const _0x491d2b = {
    id: 5,
    name: 'Great Ocean',
    doorConf: _0x7ec33b,
    panelCoords: [-2956.77, 481.13, 15.7, 270],
    powerCoords: [-2947.64, 481.09, 15.45],
    frontDoorId: 1076,
    vaultDoorId: 1077,
    innerDoorId: 515,
  }
  const _0x1adbad = {
    id: 'harmony',
    coords: [1176.45, 2712.53, 38.1],
    hash: 2121050683,
    headingClosed: 90,
    headingOpen: 0.5,
  }
  const _0x1a26ee = {
    id: 6,
    name: 'Harmony',
    doorConf: _0x1adbad,
    panelCoords: [1176.5, 2712.53, 38.1, 0],
    powerCoords: [1157.79, 2709.07, 37.98],
    frontDoorId: 1078,
    vaultDoorId: 1079,
    innerDoorId: 516,
  }
  const _0x3e3b8d = [
    _0x26eae7,
    _0x1c73cf,
    _0x3ac86c,
    _0x19ebd8,
    _0x491d2b,
    _0x1a26ee,
  ]
  const _0x2cb340 = (_0x23fb7e = 25) => {
      const _0x22d41a = GetActivePlayers(),
        _0x2e56a4 = Vector3.fromArray(GetEntityCoords(PlayerPedId(), false)),
        _0x4c9127 = []
      for (const _0x451a7a of _0x22d41a) {
        const _0x120407 = GetPlayerPed(_0x451a7a),
          _0x8c58c1 = Vector3.fromArray(GetEntityCoords(_0x120407, false)),
          _0x3572a1 = _0x2e56a4.getDistance(_0x8c58c1)
        _0x3572a1 < _0x23fb7e && _0x4c9127.push(GetPlayerServerId(_0x451a7a))
      }
      return _0x4c9127
    },
    _0x3cc3fa = async (_0x187f70, _0x3e695, _0x3e297a) => {
      const _0x2897c2 = 'anim@heists@ornate_bank@thermal_charge',
        _0x575a65 = 'hei_p_m_bag_var22_arm_s',
        _0x3a9749 = 'hei_prop_heist_thermite'
      await Promise.all([
        _0x54cae9.loadAnim(_0x2897c2),
        _0x54cae9.loadModel(_0x575a65),
        _0x54cae9.loadModel(_0x3a9749),
      ])
      const _0xdb4138 = PlayerPedId()
      SetEntityHeading(_0xdb4138, _0x187f70.h)
      await _0x4547b9(100)
      const [_0x1a0a04, _0xa1a0f5, _0x360476] = GetEntityRotation(_0xdb4138, 0),
        _0x4a2d4d = NetworkCreateSynchronisedScene(
          _0x187f70.x,
          _0x187f70.y,
          _0x187f70.z,
          _0x1a0a04,
          _0xa1a0f5,
          _0x360476 + _0x3e695,
          2,
          false,
          false,
          1065353216,
          0,
          1.3
        ),
        _0x5c27f7 = CreateObject(
          _0x575a65,
          _0x187f70.x,
          _0x187f70.y,
          _0x187f70.z,
          true,
          true,
          false
        )
      SetEntityCollision(_0x5c27f7, false, true)
      NetworkAddPedToSynchronisedScene(
        _0xdb4138,
        _0x4a2d4d,
        _0x2897c2,
        'thermal_charge',
        1.5,
        -4,
        1,
        16,
        1148846080,
        0
      )
      NetworkAddEntityToSynchronisedScene(
        _0x5c27f7,
        _0x4a2d4d,
        _0x2897c2,
        'bag_thermal_charge',
        4,
        -8,
        1
      )
      NetworkStartSynchronisedScene(_0x4a2d4d)
      await _0x4547b9(1500)
      const [_0xc03ec8, _0x5432b7, _0x100f23] = GetEntityCoords(
          _0xdb4138,
          false
        ),
        _0x520a69 = CreateObject(
          _0x3a9749,
          _0xc03ec8,
          _0x5432b7,
          _0x100f23 + 0.2,
          true,
          true,
          true
        )
      SetEntityCollision(_0x520a69, false, true)
      AttachEntityToEntity(
        _0x520a69,
        _0xdb4138,
        GetPedBoneIndex(_0xdb4138, 28422),
        0,
        0,
        0,
        0,
        0,
        200,
        true,
        true,
        false,
        true,
        1,
        true
      )
      await _0x4547b9(4000)
      DeleteObject(_0x5c27f7)
      DetachEntity(_0x520a69, true, true)
      FreezeEntityPosition(_0x520a69, true)
      NetworkStopSynchronisedScene(_0x4a2d4d)
      const _0x5dcfb8 = await _0x3e297a
      _0x5dcfb8 &&
        (TriggerServerEvent(
          'fx:ThermiteChargeEnt',
          NetworkGetNetworkIdFromEntity(_0x520a69)
        ),
        TaskPlayAnim(
          _0xdb4138,
          'anim@heists@ornate_bank@thermal_charge',
          'cover_eyes_intro',
          8,
          8,
          1000,
          36,
          1,
          false,
          false,
          false
        ),
        TaskPlayAnim(
          _0xdb4138,
          'anim@heists@ornate_bank@thermal_charge',
          'cover_eyes_loop',
          8,
          8,
          6000,
          49,
          1,
          false,
          false,
          false
        ),
        await _0x4547b9(4000),
        ClearPedTasks(_0xdb4138),
        emit('Evidence:StateSet', 16, 3600),
        emit('evidence:thermite'))
      await _0x4547b9(2000)
      _0x2e9b37.g.exports['np-sync'].SyncedExecution('DeleteEntity', +_0x520a69)
    },
    _0x4e9f3c = async (_0x493b04, _0x2de803, _0x42862e = 60) => {
      FreezeEntityPosition(_0x493b04, true)
      const _0x5ddbe3 = GetEntityHeading(_0x493b04),
        _0x5a25a3 = Math.abs(_0x5ddbe3 - _0x2de803)
      if (!_0x2de803 || Math.abs(_0x5a25a3) < 1) {
        return
      }
      const _0x5f0560 = _0x5a25a3 / _0x42862e
      let _0x5c1d40 = 0
      SetEntityCollision(_0x493b04, false, false)
      while (_0x5c1d40 <= _0x42862e) {
        await _0x4547b9(1)
        _0x5c1d40++
        if (_0x5ddbe3 > _0x2de803) {
          SetEntityHeading(_0x493b04, _0x5ddbe3 - _0x5f0560 * _0x5c1d40)
          continue
        }
        SetEntityHeading(_0x493b04, _0x5ddbe3 + _0x5f0560 * _0x5c1d40)
      }
      SetEntityHeading(_0x493b04, _0x2de803)
      FreezeEntityPosition(_0x493b04, true)
      await _0x4547b9(1)
      SetEntityCollision(_0x493b04, true, true)
    },
    _0x57a4f3 = async (_0x598217, _0x1b643a, _0x252eed) => {
      const _0x5db566 = PlayerPedId()
      ClearPedTasksImmediately(_0x5db566)
      const [_0x2a7517, _0x51c250, _0x5e8b00] = GetObjectOffsetFromCoords(
        _0x598217[0],
        _0x598217[1],
        _0x598217[2],
        _0x1b643a,
        -0.5,
        -0.2,
        0
      )
      TaskGoStraightToCoord(
        _0x5db566,
        _0x2a7517,
        _0x51c250,
        _0x5e8b00,
        2,
        -1,
        _0x1b643a,
        0
      )
      const _0x5ee8a4 = 'anim@heists@ornate_bank@hack',
        _0x3f50b4 = 'hei_prop_hst_laptop',
        _0x27d7d6 = 'hei_p_m_bag_var22_arm_s',
        _0xfab682 = 'hei_prop_heist_card_hack_02'
      await Promise.all([
        _0x54cae9.loadAnim(_0x5ee8a4),
        _0x54cae9.loadModel(_0x3f50b4),
        _0x54cae9.loadModel(_0x27d7d6),
        _0x54cae9.loadModel(_0xfab682),
      ])
      await _0x5ae501.waitForCondition(() => {
        return !GetIsTaskActive(_0x5db566, 35)
      }, 30000)
      ClearPedTasksImmediately(_0x5db566)
      await _0x4547b9(1)
      SetEntityHeading(_0x5db566, _0x1b643a)
      await _0x4547b9(1)
      TaskPlayAnim(
        _0x5db566,
        _0x5ee8a4,
        'hack_enter',
        8,
        0,
        -1,
        0,
        -1,
        false,
        false,
        false
      )
      await _0x4547b9(8300)
      const [_0x1745cc, _0x1f61f6, _0x381d0d] =
          GetOffsetFromEntityInWorldCoords(_0x5db566, 0.2, 0.6, 0),
        _0x22bcbd = CreateObject(
          _0x3f50b4,
          _0x1745cc,
          _0x1f61f6,
          _0x381d0d,
          true,
          true,
          false
        ),
        [_0x35a9d1, _0x1952c5, _0x174a99] = GetEntityRotation(_0x5db566, 2)
      SetEntityRotation(_0x22bcbd, _0x35a9d1, _0x1952c5, _0x174a99, 2, true)
      PlaceObjectOnGroundProperly(_0x22bcbd)
      TaskPlayAnim(
        _0x5db566,
        _0x5ee8a4,
        'hack_loop',
        9999,
        0.5,
        -1,
        1,
        0,
        false,
        false,
        false
      )
      await _0x252eed
      _0x2e9b37.g.exports['np-sync'].SyncedExecution('DeleteEntity', +_0x22bcbd)
      ClearPedTasksImmediately(_0x5db566)
    },
    _0x54843e = async (_0x2c1943) => {
      emit('attachItem', 'minigameDrill')
      const _0x54a387 = 'anim@heists@fleeca_bank@drilling'
      await _0x54cae9.loadAnim(_0x54a387)
      const _0xa5fad = PlayerPedId()
      TaskPlayAnim(
        _0xa5fad,
        _0x54a387,
        'drill_left',
        2,
        -8,
        180,
        49,
        0,
        false,
        false,
        false
      )
      await _0x4547b9(100)
      TaskPlayAnim(
        _0xa5fad,
        _0x54a387,
        'drill_left',
        2,
        -8,
        1800000,
        49,
        0,
        false,
        false,
        false
      )
      await _0x2c1943
      ClearPedTasksImmediately(_0xa5fad)
      emit('destroyProp')
    },
    _0x346bf0 = () => {
      const _0x2f74b6 = _0x124ede.fromArray(
        GetEntityCoords(PlayerPedId(), false)
      )
      ShootSingleBulletBetweenCoords(
        _0x2f74b6.x,
        _0x2f74b6.y,
        _0x2f74b6.z,
        _0x2f74b6.x,
        _0x2f74b6.y,
        _0x2f74b6.z + 0.5,
        0,
        true,
        GetHashKey('WEAPON_STUNGUN'),
        -1,
        true,
        false,
        5
      )
    },
    _0x3c1522 = (_0x319362, _0x1c0ba9, _0x4ccc18, _0x16d329) => {
      const _0x533b2a = _0x319362,
        [_0x1f67b8, , _0x5c0da2] = _0x1c0ba9.map(
          (_0x5e8550) => (Math.PI / 180) * _0x5e8550
        ),
        _0x396837 = Math.abs(Math.cos(_0x1f67b8)),
        _0x135c9 = [
          -Math.sin(_0x5c0da2) * _0x396837,
          Math.cos(_0x5c0da2) * _0x396837,
          Math.sin(_0x1f67b8),
        ],
        _0x3a712f = _0x135c9.map(
          (_0x20b6c6, _0x100e48) => _0x533b2a[_0x100e48] + _0x20b6c6
        ),
        _0x3e98d0 = _0x135c9.map(
          (_0x4fd097, _0x276203) => _0x533b2a[_0x276203] + _0x4fd097 * 50
        ),
        _0x2938bd = StartShapeTestSweptSphere(
          _0x3a712f[0],
          _0x3a712f[1],
          _0x3a712f[2],
          _0x3e98d0[0],
          _0x3e98d0[1],
          _0x3e98d0[2],
          0.2,
          _0x4ccc18,
          _0x16d329,
          7
        )
      return GetShapeTestResultIncludingMaterial(_0x2938bd)
    },
    _0x273abc = (
      _0x2f4de4,
      _0x5def71,
      _0xa20c91,
      _0x2b3978,
      _0x33cbab,
      _0x2d6fb1,
      _0xfb1b32 = 0
    ) => {
      SetTextColour(_0x2b3978[0], _0x2b3978[1], _0x2b3978[2], _0x2b3978[3])
      SetTextOutline()
      SetTextScale(0, _0x33cbab)
      SetTextFont(_0x2d6fb1 !== null && _0x2d6fb1 !== void 0 ? _0x2d6fb1 : 0)
      SetTextJustification(_0xfb1b32)
      if (_0xfb1b32 === 2) {
        SetTextWrap(0, 0.575)
      }
      SetTextEntry('STRING')
      AddTextComponentString(
        _0xa20c91 !== null && _0xa20c91 !== void 0 ? _0xa20c91 : 'Dummy text'
      )
      EndTextCommandDisplayText(_0x2f4de4, _0x5def71)
    }
  const _0x18b57f = () => {}
  let _0x4c7581
  RegisterUICallback('np-ui:heists:invite', async (_0xa28a57, _0x4cc166) => {
    const _0xf0f150 = await _0x349e09.execute('np-heists:ui:invite', _0xa28a57),
      _0x302bb3 = {
        ok: _0xf0f150.success,
        message: _0xf0f150.message,
      }
    const _0x3d64b1 = {}
    return (
      (_0x3d64b1.data = 'success'),
      (_0x3d64b1.meta = _0x302bb3),
      _0x4cc166(_0x3d64b1)
    )
  })
  RegisterUICallback(
    'np-ui:heists:createGroup',
    async (_0x49a261, _0x55fac8) => {
      await _0x349e09.execute('np-heists:ui:createGroup')
      const _0xb180c3 = {
        ok: true,
        message: '',
      }
      const _0x5422f2 = {}
      return (
        (_0x5422f2.data = 'success'),
        (_0x5422f2.meta = _0xb180c3),
        _0x55fac8(_0x5422f2)
      )
    }
  )
  RegisterUICallback(
    'np-ui:heists:leaveGroup',
    async (_0x1a2378, _0x182481) => {
      await _0x349e09.execute('np-heists:ui:leaveGroup')
      _0x4c7581 = null
      const _0x14ebff = {
        ok: true,
        message: '',
      }
      const _0x2fe3a2 = {}
      return (
        (_0x2fe3a2.data = 'success'),
        (_0x2fe3a2.meta = _0x14ebff),
        _0x182481(_0x2fe3a2)
      )
    }
  )
  RegisterUICallback('np-ui:heists:getGroup', async (_0x630c5e, _0x49a5a0) => {
    const _0x597a5b = await _0x349e09.execute('np-heists:ui:getGroup')
    _0x4c7581 = _0x597a5b
    const _0x4aa1c0 = {
      ok: true,
      message: '',
    }
    const _0x568a43 = {}
    return (
      (_0x568a43.data = _0x597a5b),
      (_0x568a43.meta = _0x4aa1c0),
      _0x49a5a0(_0x568a43)
    )
  })
  RegisterUICallback(
    'np-ui:heists:groupAction',
    async (_0x2985c0, _0x10d043) => {
      await _0x349e09.execute('np-heists:ui:groupAction', _0x2985c0)
      const _0x5ac063 = {
        ok: true,
        message: '',
      }
      const _0x543f83 = {}
      return (
        (_0x543f83.data = 'success'),
        (_0x543f83.meta = _0x5ac063),
        _0x10d043(_0x543f83)
      )
    }
  )
  RegisterUICallback('np-ui:heists:stop', async (_0x470de1, _0x2f212e) => {
    await _0x349e09.execute('np-heists:ui:stop', 'Leader stopped the heist')
    const _0x52a6b8 = {
      ok: true,
      message: '',
    }
    const _0x569eb5 = {}
    return (
      (_0x569eb5.data = 'success'),
      (_0x569eb5.meta = _0x52a6b8),
      _0x2f212e(_0x569eb5)
    )
  })
  _0x288d26.onNet('np-heists:ui:groupInvite', async (_0x38ced4) => {
    const _0x4b2654 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
      'vpnxj',
      1,
      false,
      true
    )
    if (!_0x4b2654) {
      return
    }
    const _0x3da36d = await _0x1a26f0.phoneConfirmation(
      'Heist Invite',
      'You were invited to a group.'
    )
    _0x3da36d && (await _0x349e09.execute('np-heists:ui:joinGroup', _0x38ced4))
  })
  _0x288d26.onNet('np-heists:ui:phoneNotification', async (_0x4086ed) => {
    _0x1a26f0.phoneNotification('Heist', _0x4086ed, true, 'heist-signups')
  })
  _0x288d26.onNet('np-heists:ui:groupUpdate', async (_0x1ea9f4) => {
    _0x4c7581 = _0x1ea9f4
  })
  on('np-heists:ui:menuInvite', async (_0x14676c, _0x42f0c5, _0x5c26c2) => {
    const _0x5769ff = NetworkGetPlayerIndexFromPed(_0x42f0c5)
    if (!_0x5769ff) {
      return
    }
    const _0xb7cfaa = GetPlayerServerId(_0x5769ff)
    if (!_0xb7cfaa) {
      return
    }
    const _0x4eee58 = {
      fromSource: true,
      groupId: _0x4c7581.id,
      serverId: _0xb7cfaa,
    }
    const _0x3fc046 = await _0x349e09.execute('np-heists:ui:invite', _0x4eee58)
    !_0x3fc046.success && emit('DoLongHudText', _0x3fc046.message, 2)
  })
  _0x2e9b37.g.exports('GetGroup', () => _0x4c7581)
  const _0xef3fa4 = 'screwdriver',
    _0x426a28 = [0.325, 0.475, 0.625, 0.775]
  let _0x50c900
  const _0x1e81a8 = async () => {
      const _0x7ac17d = RequestScaleformMovie('DRILLING'),
        _0x1dd5ec = await _0x5ae501.waitForCondition(
          () => HasScaleformMovieLoaded(_0x7ac17d),
          10000
        )
      if (_0x1dd5ec) {
        return false
      }
      RequestScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', false)
      RequestScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', false)
      _0x12d10b()
      const _0x4eb6c1 = {
        Active: true,
        DrillSpeed: 0,
        DrillPos: 0,
        DrillTemp: 0,
        HoleDepth: 0,
        HolesDrilled: _0x426a28.map((_0x137fdd) => ({
          passed: false,
          depth: _0x137fdd,
        })),
        DrillSoundId: -1,
      }
      _0x47d784(_0x7ac17d, 'SET_SPEED', _0x4eb6c1.DrillSpeed)
      _0x47d784(_0x7ac17d, 'SET_DRILL_POSITION', _0x4eb6c1.DrillPos)
      _0x47d784(_0x7ac17d, 'SET_TEMPERATURE', _0x4eb6c1.DrillTemp)
      _0x47d784(_0x7ac17d, 'SET_HOLE_DEPTH', _0x4eb6c1.HoleDepth)
      const _0x371e2f = setTick(() => {
        if (!_0x4eb6c1.Active) {
          clearTick(_0x371e2f)
          return
        }
        DrawScaleformMovieFullscreen(_0x7ac17d, 255, 255, 255, 255, 255)
        for (let _0x427095 = 8; _0x427095 <= 143; _0x427095++) {
          DisableControlAction(0, _0x427095, true)
        }
        _0x5639f3(_0x7ac17d, _0x4eb6c1)
      })
      return (
        await _0x5ae501.waitForCondition(() => !_0x4eb6c1.Active, 180000),
        StopSound(_0x4eb6c1.DrillSoundId),
        ReleaseSoundId(_0x4eb6c1.DrillSoundId),
        ReleaseNamedScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL'),
        ReleaseNamedScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2'),
        _0x4cde85(),
        _0x50c900
      )
    },
    _0x5639f3 = (_0x9207d4, _0x1787e6) => {
      const _0x2c3bff = _0x1787e6.DrillPos,
        _0x54a9d7 = GetFrameTime()
      if (_0x1787e6.DrillSoundId === -1) {
        _0x1787e6.DrillSoundId = GetSoundId()
      }
      if (IsDisabledControlJustPressed(0, 32)) {
        _0x1787e6.DrillPos = Math.min(1, _0x1787e6.DrillPos + 0.01)
        HasSoundFinished(_0x1787e6.DrillSoundId) &&
          PlaySoundFromEntity(
            _0x1787e6.DrillSoundId,
            'Drill',
            PlayerPedId(),
            'DLC_HEIST_FLEECA_SOUNDSET',
            false,
            0
          )
      } else {
        if (IsDisabledControlPressed(0, 32)) {
          _0x1787e6.DrillPos = Math.min(
            1,
            _0x1787e6.DrillPos +
              (0.1 * _0x54a9d7) / (Math.max(0.1, _0x1787e6.DrillTemp) * 10)
          )
        } else {
          if (IsDisabledControlJustPressed(0, 33)) {
            _0x1787e6.DrillPos = Math.max(0, _0x1787e6.DrillPos - 0.01)
          } else {
            IsDisabledControlPressed(0, 33) &&
              (_0x1787e6.DrillPos = Math.max(
                0,
                _0x1787e6.DrillPos - 0.1 * _0x54a9d7
              ))
          }
        }
      }
      const _0xd017bf = _0x1787e6.DrillSpeed
      if (IsDisabledControlJustPressed(0, 35)) {
        _0x1787e6.DrillSpeed = Math.min(1, _0x1787e6.DrillSpeed + 0.05)
      } else {
        if (IsDisabledControlPressed(0, 35)) {
          _0x1787e6.DrillSpeed = Math.min(
            1,
            _0x1787e6.DrillSpeed + 0.5 * _0x54a9d7
          )
        } else {
          if (IsDisabledControlJustPressed(0, 34)) {
            _0x1787e6.DrillSpeed = Math.max(0, _0x1787e6.DrillSpeed - 0.05)
          } else {
            IsDisabledControlPressed(0, 34) &&
              (_0x1787e6.DrillSpeed = Math.max(
                0,
                _0x1787e6.DrillSpeed - 0.5 * _0x54a9d7
              ))
          }
        }
      }
      if (IsDisabledControlJustPressed(0, 200)) {
        _0x50c900 = false
        _0x1787e6.Active = false
        return
      }
      const _0x2eac08 = _0x1787e6.DrillTemp
      if (_0x2c3bff < _0x1787e6.DrillPos) {
        if (_0x1787e6.DrillSpeed > 0.4) {
          SetVariableOnSound(_0x1787e6.DrillSoundId, 'DrillState', 1)
          _0x1787e6.DrillTemp = Math.min(
            1,
            _0x1787e6.DrillTemp + 0.04 * _0x54a9d7 * (_0x1787e6.DrillSpeed * 5)
          )
          _0x47d784(_0x9207d4, 'SET_DRILL_POSITION', _0x1787e6.DrillPos)
        } else {
          if (
            _0x1787e6.DrillPos < 0.1 ||
            _0x1787e6.DrillPos < _0x1787e6.HoleDepth
          ) {
            _0x47d784(_0x9207d4, 'SET_DRILL_POSITION', _0x1787e6.DrillPos)
          } else {
            _0x1787e6.DrillPos = _0x2c3bff
            _0x1787e6.DrillTemp = Math.min(
              1,
              _0x1787e6.DrillTemp + 0.01 * _0x54a9d7
            )
            SetVariableOnSound(_0x1787e6.DrillSoundId, 'DrillState', 0.5)
          }
        }
      } else {
        _0x1787e6.DrillPos < _0x1787e6.HoleDepth &&
          (SetVariableOnSound(_0x1787e6.DrillSoundId, 'DrillState', 0),
          (_0x1787e6.DrillTemp = Math.max(
            0,
            _0x1787e6.DrillTemp -
              0.05 *
                _0x54a9d7 *
                Math.max(0.005, (_0x1787e6.DrillSpeed * 10) / 2)
          )))
        _0x1787e6.DrillPos !== _0x1787e6.HoleDepth &&
          _0x47d784(_0x9207d4, 'SET_DRILL_POSITION', _0x1787e6.DrillPos)
      }
      _0xd017bf !== _0x1787e6.DrillSpeed &&
        _0x47d784(_0x9207d4, 'SET_SPEED', _0x1787e6.DrillSpeed)
      _0x2eac08 !== _0x1787e6.DrillTemp &&
        _0x47d784(_0x9207d4, 'SET_TEMPERATURE', _0x1787e6.DrillTemp)
      if (_0x1787e6.DrillTemp >= 1) {
        PlaySoundFromEntity(
          -1,
          'Drill_Jam',
          PlayerPedId(),
          'DLC_HEIST_FLEECA_SOUNDSET',
          false,
          20
        )
        _0x50c900 = false
        _0x1787e6.Active = false
      } else {
        if (_0x1787e6.DrillPos >= 0.9) {
          _0x50c900 = true
          _0x1787e6.Active = false
        }
      }
      _0x1787e6.HoleDepth =
        _0x1787e6.DrillPos > _0x1787e6.HoleDepth
          ? _0x1787e6.DrillPos
          : _0x1787e6.HoleDepth
      const _0x2ff2b0 = _0x1787e6.HolesDrilled.find(
        (_0x2318a0) =>
          _0x2318a0.depth <= _0x1787e6.HoleDepth && !_0x2318a0.passed
      )
      _0x2ff2b0 &&
        ((_0x2ff2b0.passed = true),
        PlaySoundFrontend(
          -1,
          'Drill_Pin_Break',
          'DLC_HEIST_FLEECA_SOUNDSET',
          true
        ))
    },
    _0x47d784 = (_0x54f53c, _0x3ab49a, _0x18f201) => {
      PushScaleformMovieFunction(_0x54f53c, _0x3ab49a)
      PushScaleformMovieFunctionParameterFloat(_0x18f201)
      PopScaleformMovieFunctionVoid()
    },
    _0x12d10b = async () => {
      FreezeEntityPosition(PlayerPedId(), true)
      SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
      exports['np-ui'].SetUIFocusKeepInput(true)
      exports['np-taskbar'].taskbarDisableInventory(true)
      exports['np-actionbar'].disableActionBar(true)
      emit('np-binds:should-execute', false)
    },
    _0x4cde85 = () => {
      FreezeEntityPosition(PlayerPedId(), false)
      exports['np-ui'].SetUIFocusKeepInput(false)
      exports['np-taskbar'].taskbarDisableInventory(false)
      exports['np-actionbar'].disableActionBar(false)
      emit('np-binds:should-execute', true)
    }
  const _0xa52546 = 'fire-alt',
    _0x5937b2 = 'np-ui:heistsThermiteMinigameResult'
  let _0x34a7e4,
    _0x1e403e = 1
  const _0x322e53 = async (_0x3a7061) => {
    var _0x4a59ea
    _0x34a7e4 = null
    const _0x3700f5 = !!_0x3a7061.gameFinishedEndpoint
    _0x3a7061.gameTimeoutDuration *= _0x1e403e
    ;(_0x4a59ea = _0x3a7061.gameFinishedEndpoint) !== null &&
    _0x4a59ea !== void 0
      ? _0x4a59ea
      : (_0x3a7061.gameFinishedEndpoint = _0x5937b2)
    _0x2e9b37.g.exports['np-ui'].openApplication('memorygame', _0x3a7061)
    if (_0x3700f5) {
      return
    }
    const _0x2ad5c6 = await _0x5ae501.waitForCondition(() => {
      return _0x34a7e4 !== undefined && _0x34a7e4 !== null
    }, 60000)
    if (_0x2ad5c6) {
      return false
    }
    return emitNet('np-heists:hack:track', _0x34a7e4, 'thermite'), _0x34a7e4
  }
  RegisterUICallback(_0x5937b2, async (_0x49c795, _0x5a0446) => {
    _0x34a7e4 = _0x49c795.success
    const _0x5e326e = {
      ok: true,
      message: '',
    }
    const _0x4a07b4 = {}
    return (
      (_0x4a07b4.data = 'success'),
      (_0x4a07b4.meta = _0x5e326e),
      _0x5a0446(_0x4a07b4)
    )
  })
  on('np-ui:application-closed', async (_0x44d00b) => {
    if (_0x44d00b !== 'memorygame') {
      return
    }
    ;(_0x34a7e4 === undefined || _0x34a7e4 === null) && (_0x34a7e4 = false)
  })
  _0x2e9b37.g.exports('thermiteMultiplier', (_0xf4bece) => {
    _0x1e403e = Math.min(_0xf4bece, 1.15)
  })
  _0x2e9b37.g.exports('ThermiteMinigame', _0x322e53)
  const _0x1be376 = new _0x5a531b(function () {}, 1000)
  async function _0x2d0f45() {
    const _0x2bde48 = {
      NPXEvent: 'np-heists:fleeca:rob',
      id: 'fleeca_rob',
      icon: 'th',
      label: 'Rob',
    }
    const _0x3954ae = { radius: 2.5 }
    _0x1a26f0.addPeekEntryByTarget('fleeca_rob_loc', [_0x2bde48], {
      distance: _0x3954ae,
      isEnabled: (_0x3f9a6d, _0x514076) => {
        var _0x383fcb
        const _0x38eb58 =
          (_0x383fcb = _0x514076.zones.fleeca_rob_loc) === null ||
          _0x383fcb === void 0
            ? void 0
            : _0x383fcb.id
        if (!_0x38eb58) {
          return false
        }
        const _0x1df642 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistdrill_grey',
          1,
          false,
          true
        )
        return (
          _0x1be376.isActive &&
          !_0x1be376.data.robbedLocations[_0x38eb58] &&
          _0x1df642
        )
      },
    })
    const _0x3639d9 = {
      NPXEvent: 'np-heists:fleeca:inner_door',
      id: 'fleeca_inner_door',
      icon: _0x58d72f,
      label: 'Open',
    }
    const _0x23e754 = { radius: 2.5 }
    _0x1a26f0.addPeekEntryByTarget('fleeca_inner_door', [_0x3639d9], {
      distance: _0x23e754,
      isEnabled: (_0x42732a, _0x432e90) => {
        var _0x52e3ab
        const _0x20b3b7 =
          (_0x52e3ab = _0x432e90.zones.fleeca_inner_door) === null ||
          _0x52e3ab === void 0
            ? void 0
            : _0x52e3ab.id
        if (!_0x20b3b7) {
          return false
        }
        const _0x1a5fa1 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistdecrypter_grey',
          1,
          false,
          true
        )
        return _0x1be376.isActive && !_0x1be376.data.innerDoorOpen && _0x1a5fa1
      },
    })
    for (const _0xd4111c of _0x3e3b8d) {
      _0x399ff7.addBoxZone(
        '' + _0xd4111c.id,
        'fleeca_box_zone',
        {
          x: _0xd4111c.powerCoords[0],
          y: _0xd4111c.powerCoords[1],
          z: _0xd4111c.powerCoords[2],
        },
        3,
        3,
        {
          minZ: _0xd4111c.powerCoords[2] - 1.5,
          maxZ: _0xd4111c.powerCoords[2] + 1.5,
        }
      )
    }
    _0x399ff7.onEnter('fleeca_box_zone', (_0x5ac1cc) => {
      _0x2e9b37.g.exports['np-ui'].showInteraction('Power Box')
    })
    _0x399ff7.onExit('fleeca_box_zone', () => {
      _0x2e9b37.g.exports['np-ui'].hideInteraction()
    })
    _0x399ff7.onEnter('fleeca_zone', (_0x1a947f) => {
      if (!_0x1be376.isActive) {
        return
      }
      if (_0x1a947f.id !== 'heist_' + _0x1be376.data.location.id) {
        return
      }
      _0x288d26.emitNet('np-heists:fleeca:enter')
    })
    _0x399ff7.onExit('fleeca_zone', (_0x5a2e57) => {
      if (!_0x1be376.isActive) {
        return
      }
      if (_0x5a2e57.id !== 'heist_' + _0x1be376.data.location.id) {
        return
      }
      _0x288d26.emitNet('np-heists:fleeca:exit')
    })
    const _0x43a73c = {
      x: 3,
      y: 2.25,
      z: 0,
      h: 0,
    }
    const _0x422707 = {
      x: 5,
      y: 0.75,
      z: 0,
      h: 90,
    }
    const _0x5ca55a = {
      x: 5.5,
      y: -2.75,
      z: 0,
      h: 90,
    }
    const _0xf1f1d2 = {
      x: 3,
      y: -4.5,
      z: 0,
      h: 180,
    }
    const _0x4568b6 = {
      x: 1,
      y: -2.5,
      z: 0,
      h: 270,
    }
    const _0x34d30a = [_0x43a73c, _0x422707, _0x5ca55a, _0xf1f1d2, _0x4568b6]
    _0x1be376.addHook('preStart', function () {
      const _0x124021 = this.data.location
      this.data.startCoords = _0x124021.panelCoords
      const _0x1bea3f = _0x124021.panelCoords[3] + 180
      for (let _0x51a4f2 = 0; _0x51a4f2 < 5; _0x51a4f2++) {
        const _0x417d3a = _0x34d30a[_0x51a4f2],
          [_0x1011d7, _0x46e227, _0x8e9184] = GetObjectOffsetFromCoords(
            _0x124021.panelCoords[0],
            _0x124021.panelCoords[1],
            _0x124021.panelCoords[2],
            _0x1bea3f,
            _0x417d3a.x,
            _0x417d3a.y,
            _0x417d3a.z
          ),
          _0x3b8f42 = {
            x: _0x1011d7,
            y: _0x46e227,
            z: _0x8e9184,
          }
        const _0x57ba2c = {
          heading: _0x1bea3f + _0x417d3a.h,
          minZ: _0x8e9184 - 1,
          maxZ: _0x8e9184 + 1,
        }
        _0x399ff7.addBoxTarget(
          'rob_' + this.data.location.id + '_' + _0x51a4f2,
          'fleeca_rob_loc',
          _0x3b8f42,
          0.5,
          1.8,
          _0x57ba2c
        )
      }
      const _0x5f53bd = {
        x: _0x124021.panelCoords[0],
        y: _0x124021.panelCoords[1],
        z: _0x124021.panelCoords[2],
      }
      const _0x306fc8 = {
        heading: _0x1bea3f + 90,
        minZ: _0x124021.panelCoords[2] - 10,
        maxZ: _0x124021.panelCoords[2] + 10,
      }
      _0x399ff7.addBoxZone(
        'heist_' + this.data.location.id,
        'fleeca_zone',
        _0x5f53bd,
        200,
        150,
        _0x306fc8
      )
      const [_0x3d9188, _0x195844, _0x295ef3] = GetObjectOffsetFromCoords(
          _0x124021.panelCoords[0],
          _0x124021.panelCoords[1],
          _0x124021.panelCoords[2],
          _0x1bea3f,
          2.175,
          -0.25,
          0
        ),
        _0x39746b = {
          x: _0x3d9188,
          y: _0x195844,
          z: _0x295ef3,
        }
      const _0x1000d9 = {
        heading: _0x1bea3f + 90,
        minZ: _0x295ef3 - 1,
        maxZ: _0x295ef3 + 1,
      }
      _0x399ff7.addBoxTarget(
        'inner_panel_' + this.data.location.id,
        'fleeca_inner_door',
        _0x39746b,
        0.5,
        0.5,
        _0x1000d9
      )
    })
  }
  const _0x3c2493 = async (_0x3056db, _0x312f50, _0x6fc911, _0x581611) => {
      const _0x243201 = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), true)
        ),
        _0x482058 = _0x3e3b8d.find(
          (_0x2357fa) =>
            _0x124ede.fromArray(_0x2357fa.powerCoords).getDistance(_0x243201) <
            2.5
        )
      if (!_0x482058) {
        return
      }
      const _0x2b36fc = _0x124ede.fromArray(_0x482058.powerCoords)
      if (!_0x4c7581 || _0x4c7581.heistActive) {
        emit('DoLongHudText', 'You cant do that at the moment! (Group)', 2)
        return
      }
      const _0x54f1bf = {
        label: 'Encryption Code',
        name: 'code',
      }
      const _0x36de6f = await _0x2e9b37.g.exports['np-ui'].OpenInputMenu(
        [_0x54f1bf],
        (_0x5a6fd2) => _0x5a6fd2 && _0x5a6fd2.code
      )
      if (!_0x36de6f) {
        return
      }
      const _0x530ebf = await _0x349e09.execute(
        'np-heists:fleeca:canRob',
        _0x482058.id,
        _0x36de6f.code
      )
      if (!_0x530ebf) {
        emit('DoLongHudText', 'Unavailable!', 2)
        return
      }
      emit('inventory:removeItem', 'thermitecharge', 1)
      const _0x8507a0 = {
          x: _0x2b36fc.x,
          y: _0x2b36fc.y,
          z: _0x2b36fc.z,
          h: GetEntityHeading(PlayerPedId()),
        },
        _0x555d75 = _0x109f88('minigames'),
        _0x52e310 = _0x322e53(Object.assign({}, _0x555d75.fleeca.thermite))
      _0x3cc3fa(_0x8507a0, 0, _0x52e310)
      const _0x3eb170 = await _0x52e310
      if (!_0x3eb170) {
        return
      }
      const _0x3256f8 = {
        location: _0x482058,
        code: _0x36de6f.code,
      }
      const _0x2c1057 = await _0x349e09.execute(
        'np-heists:startHeist',
        'fleeca',
        _0x3256f8
      )
    },
    _0x1a3cbf = async (_0x2c29d7, _0xce1345, _0x52ac4c, _0x488ee3) => {
      const _0x1865b8 = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), true)
        ),
        _0x28ad05 = _0x3e3b8d.find(
          (_0x54b7ed) =>
            _0x124ede.fromArray(_0x54b7ed.panelCoords).getDistance(_0x1865b8) <
            2.5
        )
      if (!_0x28ad05) {
        return
      }
      if (!_0x1be376.isActive) {
        return
      }
      emit('inventory:DegenLastUsedItem', 33)
      const _0x4cda3b = _0x109f88('minigames'),
        _0x440644 = _0x28bca6(Object.assign({}, _0x4cda3b.fleeca.laptop))
      _0x57a4f3(_0x28ad05.panelCoords, _0x28ad05.panelCoords[3], _0x440644)
      const _0x360a3e = await _0x440644
      if (!_0x360a3e) {
        return
      }
      emit('inventory:DegenLastUsedItem', 100)
      _0x288d26.emitNet('np-heists:fleeca:openVaultDoor', _0x28ad05.id)
    }
  _0x288d26.on(
    'np-heists:fleeca:rob',
    async (_0x170f00, _0x2ad38a, _0x522905) => {
      var _0x2ac88e
      const _0x31fa3c =
        (_0x2ac88e = _0x522905.zones.fleeca_rob_loc) === null ||
        _0x2ac88e === void 0
          ? void 0
          : _0x2ac88e.id
      if (!_0x31fa3c) {
        return
      }
      _0x288d26.emitNet('np-heists:fleeca:startRob', _0x31fa3c)
      emit('inventory:DegenItemType', 35, 'heistdrill_grey')
      const _0x1a23c4 = { gridSize: 4 }
      const _0x563a2b = await _0x1fae28(_0x1a23c4)
      await _0x4547b9(1000)
      _0x2e9b37.g.exports['np-ui'].closeApplication('minigame-flip')
      let _0x2758eb = false
      if (_0x563a2b) {
        const _0x3d3007 = _0x1e81a8()
        _0x54843e(_0x3d3007)
        _0x2758eb = await _0x3d3007
      }
      const _0x382b83 = await _0x349e09.execute(
        'np-heists:fleeca:rob',
        _0x31fa3c,
        _0x2758eb && _0x563a2b
      )
    }
  )
  _0x288d26.onNet('np-heists:fleeca:start', (_0x3a99ab, _0x1813fc) => {
    _0x1be376.data = {
      location: _0x3e3b8d.find((_0x25eeee) => _0x25eeee.id === _0x3a99ab),
      robbedLocations: _0x1813fc.robbedLocations,
      innerDoorOpen: _0x1813fc.innerDoorOpen,
    }
    _0x1be376.start()
  })
  _0x288d26.onNet('np-heists:fleeca:stop', () => {
    _0x1be376.stop()
  })
  _0x288d26.onNet('np-heists:fleeca:robbed', (_0x3c2425, _0x241168) => {
    _0x1be376.data.robbedLocations[_0x3c2425] = _0x241168
  })
  _0x288d26.onNet('np-heists:fleeca:innerDoorOpen', () => {
    _0x1be376.data.innerDoorOpen = true
  })
  _0x288d26.on('np-heists:fleeca:inner_door', async () => {
    if (!_0x1be376.isActive) {
      return
    }
    if (_0x1be376.data.innerDoorOpen) {
      return
    }
    emit('inventory:DegenItemType', 35, 'heistdecrypter_grey')
    const _0x25d47d = _0x109f88('minigames'),
      _0x490b68 = await _0x562cba(Object.assign({}, _0x25d47d.fleeca.untangle))
    if (!_0x490b68) {
      return
    }
    _0x288d26.emitNet(
      'np-heists:fleeca:innerDoorSuccess',
      _0x1be376.data.location.id
    )
  })
  function _0x81c45c(_0x4ba715, _0x2edaa2, _0x562abd, _0x4c19e6) {
    return new Promise((_0x2e529f) => {
      exports['np-ui'].taskBarSkill(
        _0x4ba715,
        _0x2edaa2,
        _0x2e529f,
        _0x562abd,
        _0x4c19e6
      )
    })
  }
  async function _0x102e92(_0x2f8223, _0x5add81, _0x3befad, _0x3b67e5 = false) {
    let _0xa0f7ec = false
    _0x3b67e5 && _0x2e9b37.g.exports['np-ui'].clearSkillCheck()
    for (let _0x33659e = 0; _0x33659e < _0x3befad; _0x33659e++) {
      if (!_0xa0f7ec) {
        const _0xc58d11 = await _0x81c45c(
          _0x2f8223,
          _0x5add81,
          _0x33659e % 2 !== 0,
          _0x3b67e5
        )
        if (_0xc58d11 !== 100) {
          _0xa0f7ec = true
        }
      }
    }
    return !_0xa0f7ec
  }
  const _0x32651a = new _0x5a531b(function () {}, 1000)
  async function _0xa9b9d2() {
    const _0x104c5f = {
      NPXEvent: 'np-heists:fleecaf:rob',
      id: 'fleeca_front_rob',
      icon: _0x58d72f,
      label: 'Rob',
    }
    const _0x172688 = { radius: 2.5 }
    _0x1a26f0.addPeekEntryByTarget('fleeca_front_rob_loc', [_0x104c5f], {
      distance: _0x172688,
      isEnabled: (_0x321962, _0x3d9524) => {
        var _0x55d489
        const _0x3a5499 =
          (_0x55d489 = _0x3d9524.zones.fleeca_front_rob_loc) === null ||
          _0x55d489 === void 0
            ? void 0
            : _0x55d489.id
        if (!_0x3a5499) {
          return false
        }
        return _0x32651a.isActive && !_0x32651a.data.robbedLocations[_0x3a5499]
      },
    })
    _0x399ff7.onEnter('fleeca_front_zone', (_0x1fb9b9) => {
      if (!_0x32651a.isActive) {
        return
      }
      if (_0x1fb9b9.id !== 'heist_' + _0x32651a.data.location.id) {
        return
      }
      _0x288d26.emitNet('np-heists:fleecaf:enter')
    })
    _0x399ff7.onExit('fleeca_front_zone', (_0x128f74) => {
      if (!_0x32651a.isActive) {
        return
      }
      if (_0x128f74.id !== 'heist_' + _0x32651a.data.location.id) {
        return
      }
      _0x288d26.emitNet('np-heists:fleecaf:exit')
    })
    _0x32651a.addHook('preStart', function () {
      const _0x302e6c = this.data.location
      this.data.startCoords = _0x302e6c.panelCoords
      const _0x17315d = _0x302e6c.panelCoords[3] + 180
      for (let _0x41c7ea = 0; _0x41c7ea < 4; _0x41c7ea++) {
        const [_0x2a68d1, _0x19a8db, _0x23afa1] = GetObjectOffsetFromCoords(
            _0x302e6c.panelCoords[0],
            _0x302e6c.panelCoords[1],
            _0x302e6c.panelCoords[2],
            _0x17315d,
            3.25 + -_0x41c7ea * 1.6,
            3.5,
            0
          ),
          _0x170428 = {
            x: _0x2a68d1,
            y: _0x19a8db,
            z: _0x23afa1,
          }
        const _0x408619 = {
          heading: _0x17315d + 90,
          minZ: _0x23afa1 - 1,
          maxZ: _0x23afa1 + 1,
        }
        _0x399ff7.addBoxZone(
          'rob_' + this.data.location.id + '_' + _0x41c7ea,
          'fleeca_front_rob_loc',
          _0x170428,
          1.5,
          1.75,
          _0x408619
        )
      }
      const _0x1deeb9 = {
        x: _0x302e6c.panelCoords[0],
        y: _0x302e6c.panelCoords[1],
        z: _0x302e6c.panelCoords[2],
      }
      const _0xc16d47 = {
        heading: _0x17315d + 90,
        minZ: _0x302e6c.panelCoords[2] - 10,
        maxZ: _0x302e6c.panelCoords[2] + 10,
      }
      _0x399ff7.addBoxZone(
        'heist_' + this.data.location.id,
        'fleeca_front_zone',
        _0x1deeb9,
        200,
        150,
        _0xc16d47
      )
    })
  }
  const _0x339194 = async (_0x14ccdb, _0x27c5a4, _0x407c50, _0xacf6fb) => {
    const _0x137585 = _0x2e9b37.g.exports['np-doors'].GetCurrentDoor(),
      _0x2dfbad = _0x3e3b8d.find(
        (_0x56c604) => _0x56c604.frontDoorId === _0x137585
      )
    if (!_0x2dfbad) {
      return
    }
    if (!_0x4c7581 || _0x4c7581.heistActive) {
      emit('DoLongHudText', 'You cant do that at the moment! (Group)', 2)
      return
    }
    const _0x4c069d = await _0x349e09.execute(
      'np-heists:fleecaf:canRob',
      _0x2dfbad.id
    )
    if (!_0x4c069d) {
      emit('DoLongHudText', 'Unavailable', 2)
      return
    }
    emit('inventory:DegenLastUsedItem', 33)
    const _0x45f25f = _0x109f88('minigames'),
      _0x578183 = await _0x102e92(
        _0x45f25f.fleeca_front.lockpicking.difficulty,
        _0x5ae501.getRandomNumber(
          _0x45f25f.fleeca_front.lockpicking.gapRange[0],
          _0x45f25f.fleeca_front.lockpicking.gapRange[1]
        ),
        _0x45f25f.fleeca_front.lockpicking.iterations,
        _0x45f25f.fleeca_front.lockpicking.useReverse
      )
    if (!_0x578183) {
      return
    }
    const _0x217778 = { location: _0x2dfbad }
    const _0x367fcf = await _0x349e09.execute(
      'np-heists:startHeist',
      'fleeca_front',
      _0x217778
    )
  }
  _0x288d26.on(
    'np-heists:fleecaf:rob',
    async (_0x49e282, _0x1f6c92, _0x1fe8e4) => {
      var _0x5309e3
      const _0x19269a =
        (_0x5309e3 = _0x1fe8e4.zones.fleeca_front_rob_loc) === null ||
        _0x5309e3 === void 0
          ? void 0
          : _0x5309e3.id
      if (!_0x19269a) {
        return
      }
      _0x288d26.emitNet('np-heists:fleecaf:startRob', _0x19269a)
      const _0x4a6344 = _0x109f88('minigames'),
        _0x4af76f = await _0x562cba(
          Object.assign({}, _0x4a6344.fleeca_front.untangle)
        )
      let _0x5f21a3 = true
      if (!_0x4af76f) {
        _0x5f21a3 = false
      }
      if (_0x5f21a3) {
        const _0x40c199 = await _0x1a26f0.taskBar(
          20000,
          'Downloading data...',
          true,
          {
            distance: 1,
            entity: PlayerPedId(),
          }
        )
        if (_0x40c199 !== 100) {
          _0x5f21a3 = false
        }
      }
      const _0x209c85 = await _0x349e09.execute(
        'np-heists:fleecaf:rob',
        _0x19269a,
        _0x5f21a3
      )
    }
  )
  _0x288d26.onNet('np-heists:fleecaf:start', (_0x398db2, _0x42cee7) => {
    _0x32651a.data = {
      location: _0x3e3b8d.find((_0x160dab) => _0x160dab.id === _0x398db2),
      robbedLocations: _0x42cee7,
    }
    _0x32651a.start()
  })
  _0x288d26.onNet('np-heists:fleecaf:stop', () => {
    _0x32651a.stop()
  })
  _0x288d26.onNet('np-heists:fleecaf:robbed', (_0x26ac2f, _0x159c5d) => {
    _0x32651a.data.robbedLocations[_0x26ac2f] = _0x159c5d
  })
  const _0x514931 = 'unlock-alt',
    _0x5832df = 'mini@safe_cracking',
    _0x2d34cf = 'MPSafeCracking',
    _0x1bd12e = 'SAFE_CRACK'
  let _0x213ac6
  const _0x35679b = async (_0x482ecc) => {
    _0x213ac6 = null
    await _0x54cae9.loadTexture(_0x2d34cf)
    await _0x54cae9.loadAnim(_0x5832df)
    RequestAmbientAudioBank(_0x1bd12e, false)
    _0x12d10b()
    emit('DoLongHudText', 'Press Shift+F or F to rotate, H to crack!')
    const _0x25c916 = []
    for (let _0x12d2c6 = 0; _0x12d2c6 < _0x482ecc; _0x12d2c6++) {
      const _0x4cfe9d = _0x5ae501.getRandomNumber(1, 99),
        _0x4a8c8b = {
          value: _0x4cfe9d,
          unlocked: false,
        }
      _0x25c916[_0x12d2c6] = _0x4a8c8b
    }
    let _0x30303f = 0
    const _0x83687e = (_0xc96016) => {
      const _0x4955ae = ['idle_base', 'idle_heavy_breathe', 'idle_look_around'],
        _0x41d2f6 = [
          'dial_turn_succeed_1',
          'dial_turn_succeed_2',
          'dial_turn_succeed_3',
          'dial_turn_succeed_4',
        ],
        _0x5028a3 = PlayerPedId()
      if (
        (IsEntityPlayingAnim(
          _0x5028a3,
          _0x5832df,
          'dial_turn_anti_fast_1',
          3
        ) &&
          _0xc96016 === 1) ||
        IsEntityPlayingAnim(
          _0x5028a3,
          _0x5832df,
          _0xc96016 === 2 ? _0x4955ae[_0x30303f] : _0x41d2f6[_0x30303f],
          3
        )
      ) {
        return
      }
      let _0x9292b9 = 'dial_turn_anti_fast_1'
      if (_0xc96016 === 2) {
        _0x30303f = _0x5ae501.getRandomNumber(0, _0x4955ae.length)
        _0x9292b9 = _0x4955ae[_0x30303f]
      } else {
        _0xc96016 === 3 &&
          ((_0x30303f = _0x5ae501.getRandomNumber(0, _0x41d2f6.length)),
          (_0x9292b9 = _0x41d2f6[_0x30303f]))
      }
      TaskPlayAnim(
        _0x5028a3,
        _0x5832df,
        _0x9292b9,
        8,
        -8,
        -1,
        1,
        0,
        false,
        false,
        false
      )
    }
    let _0x1ec10a = true,
      _0x1b2831 = false,
      _0x2d576d = 0,
      _0xd79516 = 0,
      _0x259229 = 0,
      _0x365afe = 1
    const _0x4df149 = setTick(async () => {
      if (!_0x1ec10a) {
        clearTick(_0x4df149)
        return
      }
      for (let _0x1f87b4 = 8; _0x1f87b4 <= 143; _0x1f87b4++) {
        DisableControlAction(0, _0x1f87b4, true)
      }
      IsDisabledControlPressed(1, 21) &&
        IsDisabledControlPressed(1, 23) &&
        _0x365afe > 1 &&
        ((_0x2d576d += 1.8),
        PlaySoundFrontend(0, 'TUMBLER_TURN', 'SAFE_CRACK_SOUNDSET', true),
        (_0x365afe = 0),
        _0x83687e(1))
      IsDisabledControlPressed(1, 23) &&
        _0x365afe > 1 &&
        ((_0x2d576d -= 1.8),
        PlaySoundFrontend(0, 'TUMBLER_TURN', 'SAFE_CRACK_SOUNDSET', true),
        (_0x365afe = 0),
        _0x83687e(1))
      if (IsDisabledControlJustPressed(0, 200)) {
        _0x213ac6 = false
        _0x1ec10a = false
        return
      }
      _0xd79516 = Math.floor(100 - _0x2d576d / 3.6)
      const _0x1194e8 = _0x25c916[_0x259229]
      IsDisabledControlJustPressed(1, 74) &&
        _0xd79516 !== _0x1194e8.value &&
        (await _0x4547b9(1000))
      if (_0x1194e8.value === _0xd79516) {
        if (!_0x1b2831) {
          PlaySoundFrontend(0, 'TUMBLER_PIN_FALL', 'SAFE_CRACK_SOUNDSET', true)
          _0x1b2831 = true
        }
        if (IsDisabledControlPressed(1, 74)) {
          _0x1b2831 = false
          PlaySoundFrontend(0, 'TUMBLER_RESET', 'SAFE_CRACK_SOUNDSET', true)
          _0x2d576d = 0
          _0xd79516 = 0
          _0x1194e8.unlocked = true
          _0x83687e(3)
          if (++_0x259229 === _0x25c916.length) {
            _0x1ec10a = false
            _0x213ac6 = true
            return
          }
        }
      } else {
        _0x1b2831 = false
      }
      _0x365afe += 7.77 * GetFrameTime()
      if (_0x2d576d < 0) {
        _0x2d576d = 360
      }
      if (_0x2d576d > 360) {
        _0x2d576d = 0
      }
      DrawSprite(
        _0x2d34cf,
        'Dial_BG',
        0.65,
        0.5,
        0.18,
        0.32,
        0,
        255,
        255,
        211,
        255
      )
      DrawSprite(
        _0x2d34cf,
        'Dial',
        0.65,
        0.5,
        0.09,
        0.16,
        _0x2d576d,
        255,
        255,
        211,
        255
      )
      let _0x33c1fb = 0.45,
        _0x306779 = 0.58
      for (const _0x3cff0a of _0x25c916) {
        _0x3cff0a.unlocked
          ? DrawSprite(
              _0x2d34cf,
              'lock_open',
              _0x306779,
              _0x33c1fb,
              0.012,
              0.024,
              0,
              255,
              255,
              211,
              255
            )
          : DrawSprite(
              _0x2d34cf,
              'lock_closed',
              _0x306779,
              _0x33c1fb,
              0.012,
              0.024,
              0,
              255,
              255,
              211,
              255
            )
        _0x33c1fb += 0.05
        const _0x47edfb = _0x25c916.indexOf(_0x3cff0a)
        if (_0x47edfb !== 0 && _0x47edfb % 10 === 0) {
          _0x33c1fb = 0.45
          _0x306779 += 0.05
        }
      }
    })
    while (_0x1ec10a) {
      await _0x4547b9(1)
    }
    return (
      _0x4cde85(),
      ClearPedTasks(PlayerPedId()),
      ReleaseAmbientAudioBank(),
      _0x213ac6
    )
  }
  const _0x5d6e67 = {
    id: 'paleto_sec_room',
    name: 'Paleto Security Room',
    model: 'prop_cctv_cam_06a',
    heading: 260,
    coords: [-89.63, 6466.38, 33.61],
  }
  const _0x465d5c = {
    id: 'paleto_back_hall',
    name: 'Paleto Back Hallway',
    model: 'prop_cctv_cam_06a',
    heading: 10,
    coords: [-99.93, 6476.86, 33.61],
  }
  const _0x1648bf = {
    id: 'paleto_lobby',
    name: 'Paleto Lobby South',
    model: 'prop_cctv_cam_06a',
    heading: 350,
    coords: [-102.18, 6476.04, 33.61],
  }
  const _0x1d5ad6 = {
    id: 'paleto_lobby_2',
    name: 'Paleto Lobby North',
    model: 'prop_cctv_cam_06a',
    heading: 175,
    coords: [-108.12, 6460.87, 33.61],
  }
  const _0x40bef4 = {
    id: 'paleto_lobby_desk',
    name: 'Paleto Lobby Desk',
    model: 'prop_cctv_cam_06a',
    heading: 80,
    coords: [-115.12, 6470.8, 33.61],
  }
  const _0x4249f0 = {
    id: 'paleto_side_hall',
    name: 'Paleto Side Hallway',
    model: 'prop_cctv_cam_06a',
    heading: 265,
    coords: [-111.01, 6475.76, 33.61],
  }
  const _0x40154c = {
    id: 'paleto_lobby_vault',
    name: 'Paleto Lobby Vault',
    model: 'prop_cctv_cam_06a',
    heading: 265,
    coords: [-99.76, 6465.37, 34],
  }
  const _0x2443e9 = {
    id: 'paleto_inner_vault',
    name: 'Paleto Inner Vault',
    model: 'prop_cctv_cam_06a',
    heading: 255,
    coords: [-95.29, 6461.19, 34],
  }
  const _0x485d56 = {
    id: 'paleto_office_1',
    name: 'Paleto Office 1',
    model: 'prop_cctv_cam_06a',
    heading: 245,
    coords: [-101.49, 6460.47, 33.61],
  }
  const _0x17c2d5 = {
    id: 'paleto_office_2',
    name: 'Paleto Office 2',
    model: 'prop_cctv_cam_06a',
    heading: 210,
    coords: [-97.32, 6464.65, 33.61],
  }
  const _0x3a05f7 = {
    id: 'paleto_office_3',
    name: 'Paleto Office 3',
    model: 'prop_cctv_cam_06a',
    heading: 20,
    coords: [-105.97, 6481.18, 33.61],
  }
  const _0x455b24 = [
    _0x5d6e67,
    _0x465d5c,
    _0x1648bf,
    _0x1d5ad6,
    _0x40bef4,
    _0x4249f0,
    _0x40154c,
    _0x2443e9,
    _0x485d56,
    _0x17c2d5,
    _0x3a05f7,
  ]
  let _0x5b135d = 0,
    _0x201fa6 = 0,
    _0x56eabc = 0,
    _0x23ec18 = 0,
    _0x1cca28 = false
  const _0x368943 = async (_0x276cc1, _0x5a7eb4) => {
      DoScreenFadeOut(400)
      await _0x4547b9(400)
      SetFocusPosAndVel(
        _0x276cc1.coords[0],
        _0x276cc1.coords[1],
        _0x276cc1.coords[2],
        0,
        0,
        0
      )
      await _0x4547b9(100)
      FreezeEntityPosition(PlayerPedId(), true)
      _0x5b135d = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
      SetCamFov(_0x5b135d, 60)
      SetCamCoord(
        _0x5b135d,
        _0x276cc1.coords[0],
        _0x276cc1.coords[1],
        _0x276cc1.coords[2] - 0.5
      )
      _0x23ec18 = _0x276cc1.heading + 180
      _0x56eabc = _0x23ec18
      _0x201fa6 = 0
      SetCamRot(_0x5b135d, 0, 0, _0x23ec18, 2)
      RenderScriptCams(true, false, 0, true, false)
      SetTimecycleModifier('CAMERA_secuirity_FUZZ')
      SetTimecycleModifierStrength(0.5)
      const _0x282266 = { display: false }
      _0x2e9b37.g.exports['np-ui'].sendAppEvent('hud', _0x282266)
      DoScreenFadeIn(1000)
      const _0x17ebc9 = GetClosestObjectOfType(
          _0x276cc1.coords[0],
          _0x276cc1.coords[1],
          _0x276cc1.coords[2] - 0.5,
          1,
          _0x276cc1.model,
          false,
          false,
          false
        ),
        _0x243052 = RequestScaleformMovie('DRONE_CAM')
      await _0x5ae501.waitForCondition(
        () => HasScaleformMovieLoaded(_0x243052),
        10000
      )
      const _0x424101 = (_0x3d2a29, _0x120889, _0xd136fe) => {
        BeginScaleformMovieMethod(_0x3d2a29, _0x120889)
        ScaleformMovieMethodAddParamBool(_0xd136fe)
        EndScaleformMovieMethod()
      }
      _0x424101(_0x243052, 'SET_RETICLE_IS_VISIBLE', true)
      let _0x1bf55a = '...',
        _0x120b15 = 0
      const _0x28219d = setTick(() => {
          if (!_0x5b135d) {
            SetScaleformMovieAsNoLongerNeeded(_0x243052)
            clearTick(_0x28219d)
            return
          }
          SetScriptGfxDrawOrder(1)
          DrawScaleformMovieFullscreen(_0x243052, 255, 255, 255, 255, 0)
          if (_0x5a7eb4) {
            const _0x2ebd73 = GetCamCoord(_0x5b135d),
              _0x3fec72 = GetCamRot(_0x5b135d, 0),
              [
                _0x5c135a,
                _0x272a56,
                _0x2267a0,
                _0x21cb31,
                _0x38071c,
                _0x32ee86,
              ] = _0x3c1522(_0x2ebd73, _0x3fec72, 16, _0x17ebc9)
            if (_0x272a56) {
              const _0x3e5a87 = _0x5a7eb4(_0x32ee86)
              _0x424101(_0x243052, 'SET_RETICLE_ON_TARGET', _0x3e5a87)
            } else {
              _0x424101(_0x243052, 'SET_RETICLE_ON_TARGET', false)
            }
            const _0x4e3c1a = GetGameTimer()
            _0x273abc(
              0.1,
              0.1,
              'OBJECT SCANNING ACTIVE' + _0x1bf55a,
              [255, 255, 255, 255],
              0.5,
              4,
              0
            )
            _0x4e3c1a - _0x120b15 > 1000 &&
              ((_0x1bf55a = _0x1bf55a.length === 3 ? '.' : _0x1bf55a + '.'),
              (_0x120b15 = _0x4e3c1a))
          }
        }),
        _0xed34a = setTick(() => {
          if (IsDisabledControlJustPressed(2, 172)) {
            _0x4245fb('up')
          }
          IsDisabledControlJustPressed(2, 173) && _0x4245fb('down')
          IsDisabledControlJustPressed(2, 174) && _0x4245fb('left')
          IsDisabledControlJustPressed(2, 175) && _0x4245fb('right')
          ;(IsDisabledControlJustReleased(2, 172) ||
            IsDisabledControlJustReleased(2, 173) ||
            IsDisabledControlJustReleased(2, 174) ||
            IsDisabledControlJustReleased(2, 175)) &&
            _0x20e4fa()
          if (IsDisabledControlJustPressed(0, 200)) {
            _0x2df954()
            clearTick(_0xed34a)
            return
          }
        })
    },
    _0x2df954 = async () => {
      if (!_0x5b135d) {
        return
      }
      DoScreenFadeOut(400)
      await _0x4547b9(400)
      ClearFocus()
      RenderScriptCams(false, false, 0, true, false)
      DoScreenFadeIn(1000)
      ClearTimecycleModifier()
      FreezeEntityPosition(PlayerPedId(), false)
      const _0x242b38 = { display: true }
      _0x2e9b37.g.exports['np-ui'].sendAppEvent('hud', _0x242b38)
      _0x5b135d = 0
    },
    _0x4245fb = (_0xd63010) => {
      if (!_0x5b135d) {
        return
      }
      _0x1cca28 = true
      const _0x38e8b3 = setTick(() => {
        if (!_0x1cca28) {
          clearTick(_0x38e8b3)
          return
        }
        switch (_0xd63010) {
          case 'up':
            _0x201fa6 += 0.1
            if (_0x201fa6 > 30) {
              _0x201fa6 = 30
            }
            break
          case 'down':
            _0x201fa6 -= 0.1
            if (_0x201fa6 < -30) {
              _0x201fa6 = -30
            }
            break
          case 'left':
            if (Math.abs(_0x56eabc - _0x23ec18) > 45) {
              break
            }
            _0x56eabc += 0.15
            if (Math.abs(_0x56eabc - _0x23ec18) <= 45) {
              break
            }
            ;(_0x56eabc -= 0.5), _0x20e4fa()
            break
          case 'right':
            if (Math.abs(_0x56eabc - _0x23ec18) > 45) {
              break
            }
            _0x56eabc -= 0.15
            if (Math.abs(_0x56eabc - _0x23ec18) <= 45) {
              break
            }
            ;(_0x56eabc += 0.5), _0x20e4fa()
            break
        }
        SetCamRot(_0x5b135d, _0x201fa6, 0, _0x56eabc, 2)
      })
    },
    _0x20e4fa = () => {
      _0x1cca28 = false
    }
  const _0x2014d9 = new _0x5a531b(function () {}, 1000),
    _0xa27777 = 'scr_cncpolicestationbustout',
    _0x4937a9 = 'scr_alarm_damage_sparks'
  let _0xfb461f = true
  const _0x5a3144 = async () => {
      const _0x4c6fb6 = {
        x: 2792.49,
        y: 1482.55,
        z: 24.53,
      }
      const _0x30dcd7 = {
        heading: 340,
        minZ: 23.33,
        maxZ: 26.53,
      }
      const _0x2ba17c = {
        ptfxCoords: [2791.18, 1482.4, 24.51],
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_power_generator',
        _0x4c6fb6,
        3,
        3,
        _0x30dcd7,
        _0x2ba17c
      )
      const _0x150f0a = {
        x: 2801.36,
        y: 1514.54,
        z: 24.54,
      }
      const _0x5e733e = {
        heading: 340,
        minZ: 23.33,
        maxZ: 26.53,
      }
      const _0x17593c = {
        ptfxCoords: [2799.66, 1514.2, 24.46],
      }
      _0x399ff7.addBoxTarget(
        '2',
        'heist_power_generator',
        _0x150f0a,
        3,
        3,
        _0x5e733e,
        _0x17593c
      )
      const _0x3dd722 = {
        x: 2810.34,
        y: 1547.69,
        z: 24.54,
      }
      const _0x3b76b5 = {
        heading: 340,
        minZ: 23.33,
        maxZ: 26.53,
      }
      const _0x111270 = {
        ptfxCoords: [2808.61, 1547.59, 24.44],
      }
      _0x399ff7.addBoxTarget(
        '3',
        'heist_power_generator',
        _0x3dd722,
        3,
        3,
        _0x3b76b5,
        _0x111270
      )
      const _0x25521c = {
        x: 2756.06,
        y: 1491.45,
        z: 24.5,
      }
      const _0x20cc45 = {
        heading: 340,
        minZ: 23.33,
        maxZ: 26.53,
      }
      const _0x4dd530 = {
        ptfxCoords: [2756.98, 1491.15, 24.36],
      }
      _0x399ff7.addBoxTarget(
        '4',
        'heist_power_generator',
        _0x25521c,
        3,
        3,
        _0x20cc45,
        _0x4dd530
      )
      const _0x2e8564 = {
        x: 2772.73,
        y: 1563.18,
        z: 24.5,
      }
      const _0x1c81d0 = {
        heading: 340,
        minZ: 23.33,
        maxZ: 26.53,
      }
      const _0xa2d2d1 = {
        ptfxCoords: [2771.72, 1563.27, 24.25],
      }
      _0x399ff7.addBoxTarget(
        '5',
        'heist_power_generator',
        _0x2e8564,
        3,
        3,
        _0x1c81d0,
        _0xa2d2d1
      )
      const _0x280a9c = {
        x: 2733.49,
        y: 1476.34,
        z: 45.3,
      }
      const _0x2086d0 = {
        heading: 340,
        minZ: 44.1,
        maxZ: 47.3,
      }
      const _0x1340c2 = {
        ptfxCoords: [2734.92, 1475.55, 45.46],
      }
      _0x399ff7.addBoxTarget(
        '6',
        'heist_power_generator',
        _0x280a9c,
        3,
        3,
        _0x2086d0,
        _0x1340c2
      )
      const _0x5a5955 = {
        x: 2741.59,
        y: 1507.02,
        z: 45.3,
      }
      const _0x50c455 = {
        heading: 340,
        minZ: 44.1,
        maxZ: 47.3,
      }
      const _0x50312a = {
        ptfxCoords: [2743.12, 1505.79, 45.45],
      }
      _0x399ff7.addBoxTarget(
        '7',
        'heist_power_generator',
        _0x5a5955,
        3,
        3,
        _0x50c455,
        _0x50312a
      )
      const _0xadd98a = {
        x: 2757.21,
        y: 1561.91,
        z: 42.89,
      }
      const _0x5caf00 = {
        heading: 340,
        minZ: 42.1,
        maxZ: 47.3,
      }
      const _0x3f903b = {
        ptfxCoords: [2759.01, 1562.72, 43.56],
      }
      _0x399ff7.addBoxTarget(
        '8',
        'heist_power_generator',
        _0xadd98a,
        3,
        3,
        _0x5caf00,
        _0x3f903b
      )
      const _0x173651 = {
        id: 'heist_power_generators',
        label: 'Activate',
        icon: _0x38020f,
        NPXEvent: 'np-heists:powerstation:generator',
      }
      const _0x16c9c6 = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget('heist_power_generator', [_0x173651], {
        distance: _0x16c9c6,
        isEnabled: (_0x17b225, _0x2055d6) => {
          var _0x24324b
          const _0x2e9fe2 =
              (_0x24324b = _0x2055d6.zones.heist_power_generator) === null ||
              _0x24324b === void 0
                ? void 0
                : _0x24324b.id,
            _0x27f289 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
              'heistelectronickit_red',
              1,
              false,
              true
            )
          return (
            _0x2e9fe2 &&
            _0x2014d9.isActive &&
            _0x27f289 &&
            !_0x2014d9.data.generators[_0x2e9fe2] &&
            !(
              _0x2014d9.data.generatorAttempts[_0x2e9fe2] &&
              _0x2014d9.data.generatorAttempts[_0x2e9fe2] > 5
            )
          )
        },
      })
    },
    _0x50e068 = (_0x113621, _0x42e070, _0x181458, _0x5018e6) => {
      const _0x5afea0 = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), false)
        ),
        _0x56d490 = new _0x124ede(2791.18, 1482.4, 24.51)
      if (!_0x4c7581 || _0x4c7581.heistActive) {
        emit('DoLongHudText', 'You cant do that at the moment! (Group)', 2)
        return
      }
      if (_0x5afea0.getDistance(_0x56d490) > 250) {
        emit('DoLongHudText', 'Nothing happened...', 2)
        return
      }
      const _0xb4919e = _0x349e09.execute(
        'np-heists:startHeist',
        'powerstation',
        {}
      )
      if (!_0xb4919e) {
        emit('DoLongHudText', 'Unavailable', 2)
        return
      }
      emit('DoLongHudText', 'Jamming Device Active')
      emit('inventory:removeItem', _0x113621, 1)
    }
  _0x288d26.onNet('np-heists:generator:attempt', (_0x258b74, _0x18dc44) => {
    _0x2014d9.data.generatorAttempts[_0x258b74] = _0x18dc44
  })
  _0x288d26.on(
    'np-heists:powerstation:generator',
    async (_0x154d1a, _0x538c69, _0x581aad) => {
      const _0x4401c2 = _0x581aad.zones.heist_power_generator.id
      if (
        !_0x2014d9.isActive ||
        !_0x4401c2 ||
        _0x2014d9.data.generators[_0x4401c2] ||
        (_0x2014d9.data.generatorAttempts[_0x4401c2] &&
          _0x2014d9.data.generatorAttempts[_0x4401c2] > 5)
      ) {
        return
      }
      _0x288d26.emitNet('np-heists:generator:start', _0x4401c2)
      emit('inventory:DegenItemType', 8, 'heistelectronickit_red')
      const _0x18fcd9 = +_0x4401c2,
        _0x9c07f4 = _0x109f88('minigames'),
        _0x472f8c =
          _0x18fcd9 <= 3
            ? _0x9c07f4.powerstation['ddr-1']
            : _0x18fcd9 <= 6
            ? _0x9c07f4.powerstation['ddr-2']
            : _0x9c07f4.powerstation['ddr-3'],
        _0x45951d = await _0xd70562(Object.assign({}, _0x472f8c))
      if (!_0x45951d) {
        return
      }
      const _0x271c3e = _0x581aad.zones.heist_power_generator.ptfxCoords,
        _0xd62814 = await _0x349e09.execute(
          'np-heists:generator:explode',
          _0x4401c2,
          _0x271c3e
        )
    }
  )
  _0x288d26.onNet(
    'np-heists:generator:exploded',
    async (_0x3e0abc, _0xc0a537) => {
      _0x2014d9.data.generators[_0x3e0abc] = true
      await _0x54cae9.loadNamedPtfxAsset(_0xa27777)
      UseParticleFxAssetNextCall(_0xa27777)
      SetPtfxAssetNextCall(_0xa27777)
      StartParticleFxLoopedAtCoord(
        _0x4937a9,
        _0xc0a537[0],
        _0xc0a537[1],
        _0xc0a537[2],
        0,
        180,
        0,
        10,
        false,
        false,
        false,
        false
      )
    }
  )
  _0x288d26.onNet('np-heists:powerstation:start', (_0x5488a2) => {
    _0x2014d9.data = _0x5488a2
    _0x2014d9.start()
  })
  _0x288d26.onNet('np-heists:powerstation:stop', () => {
    _0x2014d9.stop()
    _0x421a00(0, 0)
  })
  onNet('sv-heists:cityPowerState', (_0x4f4e5b) => {
    _0xfb461f = _0x4f4e5b
  })
  let _0x1663d8
  const _0x421a00 = (_0x5d28b2, _0x5640a0) => {
    const _0xc51d74 = PlayerId()
    SetMaxWantedLevel(_0x5d28b2)
    SetPlayerWantedLevel(_0xc51d74, _0x5d28b2, false)
    SetPlayerWantedLevelNow(_0xc51d74, false)
    SetPlayerWantedLevelNoDrop(_0xc51d74, _0x5d28b2, false)
    for (let _0x179604 = 0; _0x179604 < 25; _0x179604++) {
      EnableDispatchService(_0x179604, true)
    }
    clearTimeout(_0x1663d8)
    _0x1663d8 = setTimeout(() => {
      SetMaxWantedLevel(0)
      SetPlayerWantedLevel(_0xc51d74, 0, false)
      SetPlayerWantedLevelNoDrop(_0xc51d74, 0, false)
      SetPlayerWantedLevelNow(_0xc51d74, false)
      for (let _0x504a1e = 0; _0x504a1e < 25; _0x504a1e++) {
        EnableDispatchService(_0x504a1e, false)
      }
    }, _0x5640a0)
  }
  _0x288d26.onNet('np-heists:powerstation:setWanted', (_0x2e8235) => {
    if (_0x2e8235) {
      _0x421a00(2, 240000)
      return
    }
    _0x421a00(0, 0)
  })
  const _0x1cc2c7 = async () => {
    const _0x5a0a6f = {
      startScale: 5,
      toScale: 15,
    }
    const { startScale: _0x3b5742, toScale: _0x216913 } = _0x5a0a6f,
      [_0x3cef7b, _0x4a5183, _0x190ca6] = [2854.3, 1550.34, 24.58],
      [_0x397ed0, _0x207bb3, _0x364e8d] = [2837.5, 1556.19, 24.74],
      [_0x2ad8cf, _0x23cd9e, _0x23dddf] = [2825.65, 1512.43, 24.58]
    await _0x54cae9.loadNamedPtfxAsset(_0xa27777)
    UseParticleFxAssetNextCall(_0xa27777)
    SetPtfxAssetNextCall(_0xa27777)
    StartParticleFxLoopedAtCoord(
      _0x4937a9,
      _0x3cef7b,
      _0x4a5183,
      _0x190ca6,
      0,
      180,
      0,
      _0x3b5742 * 10,
      false,
      false,
      false,
      false
    )
    await _0x4547b9(400)
    if (IsStreamPlaying()) {
      StopStream()
    }
    await _0x5ae501.waitForCondition(
      () =>
        LoadStream('submarine_explosions_stream', 'dlc_xm_submarine_sounds'),
      30000
    )
    PlayStreamFromPosition(2854.3, 1550.34, 24.58)
    UseParticleFxAssetNextCall(_0xa27777)
    SetPtfxAssetNextCall(_0xa27777)
    StartParticleFxLoopedAtCoord(
      _0x4937a9,
      _0x397ed0,
      _0x207bb3,
      _0x364e8d,
      0,
      180,
      0,
      _0x3b5742 * 10,
      false,
      false,
      false,
      false
    )
    await _0x4547b9(200)
    let _0x11518d = true,
      _0x488272 = _0x3b5742 / 2,
      _0x2f2bda = 1
    const _0x106493 = setTick(() => {
      if (!_0x11518d) {
        clearTick(_0x106493)
        return
      }
      const _0x7ab0db = GetFrameTime()
      _0x488272 += 0.5 * _0x2f2bda * _0x7ab0db
      if (_0x488272 > (_0x3b5742 / 2) * 1.1) {
        _0x2f2bda = -1
      } else {
        if (_0x488272 < _0x3b5742) {
          _0x2f2bda = 1
        }
      }
    })
    await _0x4547b9(1500)
    const _0x2473d5 = 'scr_xs_dr',
      _0x463826 = 'scr_xs_dr_emp'
    await _0x54cae9.loadNamedPtfxAsset(_0x2473d5)
    let _0x4839df = 1000
    while (_0x4839df > 200) {
      const [_0x171b36, _0x494c50, _0x1971d9] =
        Math.random() > 0.5
          ? [_0x3cef7b, _0x4a5183, _0x190ca6]
          : [_0x2ad8cf, _0x23cd9e, _0x23dddf]
      UseParticleFxAssetNextCall(_0x2473d5)
      SetPtfxAssetNextCall(_0x2473d5)
      StartParticleFxLoopedAtCoord(
        _0x463826,
        _0x171b36,
        _0x494c50,
        _0x1971d9,
        0,
        180,
        0,
        _0x3b5742,
        false,
        false,
        false,
        false
      )
      UseParticleFxAssetNextCall(_0xa27777)
      SetPtfxAssetNextCall(_0xa27777)
      StartParticleFxLoopedAtCoord(
        _0x4937a9,
        _0x397ed0,
        _0x207bb3,
        _0x364e8d,
        0,
        180,
        0,
        _0x3b5742 * 10,
        false,
        false,
        false,
        false
      )
      _0x4839df -= _0x4839df / 10
      await _0x4547b9(_0x4839df)
    }
    _0x11518d = false
    UseParticleFxAssetNextCall(_0x2473d5)
    SetPtfxAssetNextCall(_0x2473d5)
    StartParticleFxLoopedAtCoord(
      _0x463826,
      _0x3cef7b,
      _0x4a5183,
      _0x190ca6,
      0,
      180,
      0,
      _0x3b5742 * 20,
      false,
      false,
      false,
      false
    )
    let _0x1afe2d = _0x3b5742,
      _0x59cd2a = 0,
      _0x597dab = 0,
      _0x54bba2 = true
    const _0x5a57d5 = setTick(() => {
      if (!_0x54bba2) {
        clearTick(_0x5a57d5)
        return
      }
      const _0x3c6c54 = GetFrameTime()
      _0x59cd2a += 20 * _0x3c6c54
      if (_0x59cd2a > 360) {
        _0x59cd2a = 0
      }
      _0x597dab += 10 * _0x3c6c54
      _0x597dab > 360 && (_0x597dab = 0)
    })
    while (_0x1afe2d < _0x3b5742 * _0x216913) {
      _0x1afe2d += 23 * (_0x216913 / _0x1afe2d)
      await _0x4547b9(1)
    }
    await _0x4547b9(200)
    while (_0x1afe2d > 0) {
      await _0x4547b9(1)
      _0x1afe2d -= 24 * (_0x216913 / _0x1afe2d)
    }
    _0x54bba2 = false
    PlaySoundFromCoord(
      -1,
      'EMP_vehicle_affected',
      -80.35,
      -821.42,
      703.01,
      'DLC_AW_EMP_Sounds',
      false,
      0,
      false
    )
    const _0x1523ff = 'scr_agencyheistb',
      _0x5c67b5 = 'scr_agency3b_heli_exp_trail'
    await _0x54cae9.loadNamedPtfxAsset(_0x1523ff)
    UseParticleFxAssetNextCall(_0x1523ff)
    SetPtfxAssetNextCall(_0x1523ff)
    const _0x112197 = StartParticleFxLoopedAtCoord(
      _0x5c67b5,
      _0x3cef7b,
      _0x4a5183,
      _0x190ca6,
      0,
      180,
      0,
      _0x3b5742 * 3,
      false,
      false,
      false,
      false
    )
    SetParticleFxLoopedColour(_0x112197, 75, 0, 130, false)
    let _0x931403 = _0x3b5742,
      _0x4c3fe0 = false
    const _0x34c672 = setTick(() => {
      const _0x28bbc4 = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), false)
        ),
        _0x2efec3 = _0x28bbc4.getDistanceFromArray([
          _0x3cef7b,
          _0x4a5183,
          _0x190ca6,
        ])
      !_0x4c3fe0 &&
        _0x2efec3 < _0x931403 + 112 &&
        (PlaySoundFrontend(
          -1,
          'EMP_vehicle_affected',
          'DLC_AW_EMP_Sounds',
          false
        ),
        (_0x4c3fe0 = true))
    })
    let _0xfb4206 = 0
    const _0x4003d7 = setTick(async () => {
      if (_0xfb4206 >= 4) {
        clearTick(_0x4003d7)
        return
      }
      const _0x16c606 = [
          [2821.12, 1398.98, 53.81],
          [2710.12, 1240.06, 62.38],
          [2649.21, 1017.1, 106.02],
          [2618.62, 862.89, 127.25],
        ],
        _0x5bdc74 = [
          [2868.86, 1608.26, 57.22],
          [2857.18, 1732.46, 72.05],
          [2677.8, 1737.18, 65.27],
          [2637.48, 1929.31, 66.82],
        ],
        [_0x55c56f, _0xe4c44b, _0x4ac92c] = _0x16c606[_0xfb4206],
        [_0x543044, _0x994ee8, _0x347cd9] = _0x5bdc74[_0xfb4206]
      UseParticleFxAssetNextCall(_0xa27777)
      SetPtfxAssetNextCall(_0xa27777)
      StartParticleFxLoopedAtCoord(
        _0x4937a9,
        _0x55c56f,
        _0xe4c44b,
        _0x4ac92c,
        0,
        180,
        0,
        _0x3b5742 * 10,
        false,
        false,
        false,
        false
      )
      UseParticleFxAssetNextCall(_0xa27777)
      SetPtfxAssetNextCall(_0xa27777)
      StartParticleFxLoopedAtCoord(
        _0x4937a9,
        _0x543044,
        _0x994ee8,
        _0x347cd9,
        0,
        180,
        0,
        _0x3b5742 * 10,
        false,
        false,
        false,
        false
      )
      await _0x4547b9(250)
      _0xfb4206++
    })
    while (_0x931403 < 40000) {
      const _0x193beb = GetFrameTime()
      _0x931403 += 250 * _0x193beb
      await _0x4547b9(1)
    }
    clearTick(_0x34c672)
    clearTick(_0x4003d7)
  }
  onNet('np-heists:powerstation:explodeStation', _0x1cc2c7)
  _0x2e9b37.g.exports('CityPowerState', () => _0xfb461f)
  const _0xa68863 = 'window-maximize',
    _0x1e3ff2 = 'np-ui:heistsMazeMinigameResult'
  let _0x4a38ce
  const _0x20c641 = async (_0x8eb315) => {
    var _0x4e6150
    _0x4a38ce = null
    const _0x41d161 = !!_0x8eb315.gameFinishedEndpoint
    ;(_0x4e6150 = _0x8eb315.gameFinishedEndpoint) !== null &&
    _0x4e6150 !== void 0
      ? _0x4e6150
      : (_0x8eb315.gameFinishedEndpoint = _0x1e3ff2)
    exports['np-ui'].openApplication('minigame-maze', _0x8eb315)
    if (_0x41d161) {
      return
    }
    const _0xf7e862 = await _0x5ae501.waitForCondition(() => {
      return _0x4a38ce !== undefined && _0x4a38ce !== null
    }, 60000)
    if (_0xf7e862) {
      return false
    }
    return emitNet('np-heists:hack:track', _0x4a38ce, 'maze'), _0x4a38ce
  }
  RegisterUICallback(_0x1e3ff2, async (_0xdfbc75, _0x29fd9d) => {
    _0x4a38ce = _0xdfbc75.success
    const _0x1ed40e = {
      ok: true,
      message: '',
    }
    const _0x111167 = {}
    return (
      (_0x111167.data = 'success'),
      (_0x111167.meta = _0x1ed40e),
      _0x29fd9d(_0x111167)
    )
  })
  on('np-ui:application-closed', async (_0x5643a1) => {
    if (_0x5643a1 !== 'minigame-maze') {
      return
    }
    await _0x4547b9(2500)
    ;(_0x4a38ce === undefined || _0x4a38ce === null) && (_0x4a38ce = false)
  })
  _0x2e9b37.g.exports('MazeMinigame', _0x20c641)
  const _0x2bd9e1 = 'window-restore',
    _0x3eab50 = 'np-ui:heistsVarMinigameResult'
  let _0x103160
  const _0xe267e1 = async (_0x1a5bce) => {
    var _0x16dd54
    _0x103160 = null
    const _0x44301d = !!_0x1a5bce.gameFinishedEndpoint
    ;(_0x16dd54 = _0x1a5bce.gameFinishedEndpoint) !== null &&
    _0x16dd54 !== void 0
      ? _0x16dd54
      : (_0x1a5bce.gameFinishedEndpoint = _0x3eab50)
    _0x2e9b37.g.exports['np-ui'].openApplication(
      'minigame-serverroom',
      _0x1a5bce
    )
    if (_0x44301d) {
      return
    }
    const _0x26f678 = await _0x5ae501.waitForCondition(() => {
      return _0x103160 !== undefined && _0x103160 !== null
    }, 60000)
    if (_0x26f678) {
      return false
    }
    return emitNet('np-heists:hack:track', _0x103160, 'serverroom'), _0x103160
  }
  RegisterUICallback(_0x3eab50, async (_0x813e93, _0x100171) => {
    _0x103160 = _0x813e93.success
    const _0x19a32c = {
      ok: true,
      message: '',
    }
    const _0x3103bd = {}
    return (
      (_0x3103bd.data = 'success'),
      (_0x3103bd.meta = _0x19a32c),
      _0x100171(_0x3103bd)
    )
  })
  on('np-ui:application-closed', async (_0x3704c5) => {
    if (_0x3704c5 !== 'minigame-serverroom') {
      return
    }
    await _0x4547b9(2500)
    ;(_0x103160 === undefined || _0x103160 === null) && (_0x103160 = false)
  })
  _0x2e9b37.g.exports('VarMinigame', _0xe267e1)
  _0x288d26.on(
    'np-heists:paleto:officePCTask',
    async (_0x18d707, _0x348625, _0x229f78) => {
      var _0x1f59b0
      const _0x45ccab =
        (_0x1f59b0 = _0x229f78.zones.heist_paleto_officepc) === null ||
        _0x1f59b0 === void 0
          ? void 0
          : _0x1f59b0.id
      if (!_0x45ccab) {
        return
      }
      const _0x16dc3d = await _0x1a26f0.taskBar(
        25000,
        'Downloading data...',
        true,
        {
          distance: 1,
          entity: PlayerPedId(),
        }
      )
      if (!_0x16dc3d) {
        return
      }
      _0x349e09.execute('np-heists:paleto:completeTask', 'officePC', +_0x45ccab)
    }
  )
  _0x288d26.on(
    'np-heists:paleto:sideKeypadTask',
    async (_0x12c32d, _0x16a893, _0x45a934) => {
      const _0x5d1a8c = {
        gameTimeoutDuration: 14000,
        coloredSquares: 14,
        gridSize: 5,
      }
      const _0x3d7d45 = await _0x322e53(_0x5d1a8c)
      if (!_0x3d7d45) {
        return
      }
      _0x349e09.execute('np-heists:paleto:completeTask', 'sideKeypad', 1)
    }
  )
  _0x288d26.on(
    'np-heists:paleto:hallPowerTask',
    async (_0x4b5e62, _0x2a496d, _0x2114e3) => {
      const _0x2b8ecc = {
        letters: ['w', 'a', 's', 'd', 'i', 'j', 'k', 'l'],
        gameTimeoutDuration: 35000,
        failureCount: 3,
        timeBetweenLetters: 550,
        timeToTravel: 1200,
        columns: 4,
      }
      const _0x3850d4 = _0xd70562(_0x2b8ecc)
      if (!_0x3850d4) {
        return
      }
      _0x349e09.execute('np-heists:paleto:completeTask', 'hallPower', 1)
    }
  )
  _0x288d26.on(
    'np-heists:paleto:frontDeskTask',
    async (_0x4ef988, _0x52326d, _0x1eaa2b) => {
      const _0x3aadd2 = {
        numberTimeout: 5000,
        squares: 7,
      }
      const _0x540758 = await _0xe267e1(_0x3aadd2)
      if (!_0x540758) {
        return
      }
      _0x349e09.execute('np-heists:paleto:completeTask', 'frontDesk', 1)
    }
  )
  _0x288d26.on(
    'np-heists:paleto:payphoneTask',
    async (_0x2e583c, _0x28eb57, _0x56780c) => {
      var _0x1e8c8a
      const _0x171861 =
        (_0x1e8c8a = _0x56780c.zones.heist_paleto_payphone) === null ||
        _0x1e8c8a === void 0
          ? void 0
          : _0x1e8c8a.id
      if (!_0x171861) {
        return
      }
      const _0xa2030c = {
        gridSize: 5,
        numberHideDuration: 4500,
      }
      const _0x44b956 = await _0x20c641(_0xa2030c)
      if (!_0x44b956) {
        return
      }
      _0x349e09.execute('np-heists:paleto:completeTask', 'payphone', +_0x171861)
    }
  )
  _0x288d26.on(
    'np-heists:paleto:atmTask',
    async (_0x4ab445, _0x280dfd, _0x2c8ddc) => {
      var _0xb323c0
      const _0x202643 =
        (_0xb323c0 = _0x2c8ddc.zones.heist_paleto_atm) === null ||
        _0xb323c0 === void 0
          ? void 0
          : _0xb323c0.id
      if (!_0x202643) {
        return
      }
      const _0xc2552 = {
        gridSize: 4,
        gameTimeoutDuration: 10000,
      }
      const _0x57f11a = await _0x1fae28(_0xc2552)
      if (!_0x57f11a) {
        return
      }
      _0x349e09.execute('np-heists:paleto:completeTask', 'atm', +_0x202643)
    }
  )
  const _0x27316e = new _0x5a531b(function () {}, 1000),
    _0x36bed3 = async () => {
      const _0x1b397d = {
        x: 2585.87,
        y: 5065.81,
        z: 44.92,
      }
      const _0x459141 = {
        heading: 20,
        minZ: 42.17,
        maxZ: 46.12,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_powerstation',
        _0x1b397d,
        1.6,
        1.6,
        _0x459141
      )
      const _0x110bb0 = {
        x: 1350.98,
        y: 6388.13,
        z: 33.21,
      }
      const _0x1993df = {
        heading: 0,
        minZ: 32.21,
        maxZ: 34.21,
      }
      _0x399ff7.addBoxTarget(
        '2',
        'heist_paleto_powerstation',
        _0x110bb0,
        1,
        1,
        _0x1993df
      )
      const _0x430f61 = {
        x: 224.59,
        y: 6397.89,
        z: 31.41,
      }
      const _0x1c6439 = {
        heading: 25,
        minZ: 30.41,
        maxZ: 32.41,
      }
      _0x399ff7.addBoxTarget(
        '3',
        'heist_paleto_powerstation',
        _0x430f61,
        1,
        1,
        _0x1c6439
      )
      const _0x374c18 = {
        id: 'h_paleto_powerstation',
        label: 'Activate',
        icon: _0x38020f,
        NPXEvent: 'np-heists:paleto:powerstation',
      }
      const _0x265911 = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget('heist_paleto_powerstation', [_0x374c18], {
        distance: _0x265911,
        isEnabled: () => {
          const _0x8a369a = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'heistelectronickit_blue',
            1,
            false,
            true
          )
          return _0x8a369a
        },
      })
      const _0x20c4b7 = {
        x: -97.58,
        y: 6455.66,
        z: 31.46,
      }
      const _0x578519 = {
        heading: 43,
        minZ: 28.71,
        maxZ: 32.66,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_atm',
        _0x20c4b7,
        0.6,
        1.6,
        _0x578519
      )
      const _0x250298 = {
        x: -95.82,
        y: 6457.42,
        z: 31.46,
      }
      const _0x5b1910 = {
        heading: 45,
        minZ: 28.71,
        maxZ: 32.66,
      }
      _0x399ff7.addBoxTarget(
        '2',
        'heist_paleto_atm',
        _0x250298,
        0.6,
        1.6,
        _0x5b1910
      )
      const _0x37501d = {
        x: -91.97,
        y: 6462.6,
        z: 31.47,
      }
      const _0x11f48b = {
        heading: 46,
        minZ: 28.72,
        maxZ: 32.67,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_payphone',
        _0x37501d,
        0.6,
        1.6,
        _0x11f48b
      )
      const _0x503b72 = {
        x: -90.57,
        y: 6464.04,
        z: 31.47,
      }
      const _0x2c36ee = {
        heading: 46,
        minZ: 28.72,
        maxZ: 32.67,
      }
      _0x399ff7.addBoxTarget(
        '2',
        'heist_paleto_payphone',
        _0x503b72,
        0.6,
        1.6,
        _0x2c36ee
      )
      const _0x5eb6cc = {
        x: -85.06,
        y: 6461.18,
        z: 31.51,
      }
      const _0x431d0b = {
        heading: 46,
        minZ: 28.76,
        maxZ: 32.71,
      }
      _0x399ff7.addBoxZone(
        'paleto',
        'fleeca_box_zone',
        _0x5eb6cc,
        1.4,
        1.6,
        _0x431d0b
      )
      const _0x27639b = {
        x: -97.34,
        y: 6475.11,
        z: 31.43,
      }
      const _0x373a28 = {
        heading: 46,
        minZ: 28.68,
        maxZ: 32.63,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_outsidedoor',
        _0x27639b,
        1.2,
        0.4,
        _0x373a28
      )
      const _0x208185 = {
        id: 'h_paleto_outsidedoor',
        label: 'Activate',
        icon: _0x58d72f,
        NPXEvent: 'np-heists:paleto:backDoor',
      }
      const _0x5e3cfc = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget('heist_paleto_outsidedoor', [_0x208185], {
        distance: _0x5e3cfc,
        isEnabled: () => {
          const _0x3f8141 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'heistdecrypter_blue',
            1,
            false,
            true
          )
          return (
            _0x27316e.isActive &&
            _0x3f8141 &&
            !_0x27316e.data.openDoors.backDoor
          )
        },
      })
      const _0x1eeffd = {
        x: -92.88,
        y: 6469.94,
        z: 31.65,
      }
      const _0x5ef8ea = {
        heading: 46,
        minZ: 28.9,
        maxZ: 32.85,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_secdoor',
        _0x1eeffd,
        1.2,
        0.4,
        _0x5ef8ea
      )
      const _0x35f1ec = {
        id: 'h_paleto_secdoor',
        label: 'Activate',
        icon: _0x58d72f,
        NPXEvent: 'np-heists:paleto:securityDoor',
      }
      const _0xc41ea5 = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget('heist_paleto_secdoor', [_0x35f1ec], {
        distance: _0xc41ea5,
        isEnabled: () => {
          const _0x19bfac = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'heistdecrypter_blue',
            1,
            false,
            true
          )
          return (
            _0x27316e.isActive &&
            _0x19bfac &&
            !_0x27316e.data.openDoors.securityDoor
          )
        },
      })
      const _0x4fe6e3 = {
        x: -91.68,
        y: 6464.8,
        z: 31.63,
      }
      const _0x338a6f = {
        heading: 46,
        minZ: 31.43,
        maxZ: 31.98,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_seccams',
        _0x4fe6e3,
        0.8,
        1.2,
        _0x338a6f
      )
      const _0x2adda7 = {
        x: -94.89,
        y: 6462.67,
        z: 31.63,
      }
      const _0x11cf24 = {
        heading: 136,
        minZ: 31.43,
        maxZ: 31.98,
      }
      _0x399ff7.addBoxTarget(
        '2',
        'heist_paleto_seccams',
        _0x2adda7,
        1,
        2.2,
        _0x11cf24
      )
      const _0x34fbd8 = {
        x: -93.03,
        y: 6463.62,
        z: 31.63,
      }
      const _0x29d137 = {
        heading: 45,
        minZ: 31.33,
        maxZ: 31.73,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_doorcontrol',
        _0x34fbd8,
        0.6,
        1,
        _0x29d137
      )
      const _0x50203e = {
        id: 'h_paleto_seccams',
        label: 'Activate',
        icon: 'video',
        NPXEvent: 'np-heists:paleto:viewSecurityCams',
      }
      const _0x49c79c = { radius: 2.5 }
      const _0x335209 = {
        distance: _0x49c79c,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_seccams',
        [_0x50203e],
        _0x335209
      )
      const _0x23c395 = {
        id: 'h_paleto_doorcontrol',
        label: 'Control Panel',
        icon: 'laptop-house',
        NPXEvent: 'np-heists:paleto:doorControl',
      }
      const _0x57f75e = { radius: 2.5 }
      const _0x1c1101 = {
        distance: _0x57f75e,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_doorcontrol',
        [_0x23c395],
        _0x1c1101
      )
      const _0x14bb49 = {
        x: -105.29,
        y: 6480.63,
        z: 31.63,
      }
      const _0xe142f4 = {
        heading: 136,
        minZ: 31.63,
        maxZ: 32.38,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_safe',
        _0x14bb49,
        0.2,
        0.8,
        _0xe142f4
      )
      const _0x1a6408 = {
        id: 'h_paleto_safe',
        label: 'Crack Safe',
        icon: _0x514931,
        NPXEvent: 'np-heists:paleto:safeCrack',
      }
      const _0x46515f = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget('heist_paleto_safe', [_0x1a6408], {
        distance: _0x46515f,
        isEnabled: () => {
          return _0x27316e.isActive
        },
      })
      const _0x3ca7fb = {
        x: -106.46,
        y: 6473.64,
        z: 31.63,
      }
      const _0x12add1 = {
        heading: 136,
        minZ: 31.28,
        maxZ: 31.83,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_frontdesk',
        _0x3ca7fb,
        1.4,
        0.8,
        _0x12add1
      )
      const _0x3839fc = {
        x: -117.95,
        y: 6470.23,
        z: 31.63,
      }
      const _0x212efc = {
        heading: 226,
        minZ: 30.88,
        maxZ: 32.83,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_hallpower',
        _0x3839fc,
        1.4,
        0.4,
        _0x212efc
      )
      const _0x5ac13c = {
        x: -115.29,
        y: 6479.99,
        z: 31.65,
      }
      const _0x1be8fe = {
        heading: 226,
        minZ: 31.7,
        maxZ: 32.25,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_sidekeypad',
        _0x5ac13c,
        0.2,
        0.4,
        _0x1be8fe
      )
      const _0x13471a = {
        x: -115.61,
        y: 6480.26,
        z: 31.47,
      }
      const _0x2f4dde = {
        heading: 226,
        minZ: 31.72,
        maxZ: 32.27,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_sideoutsidekeypad',
        _0x13471a,
        0.2,
        0.4,
        _0x2f4dde
      )
      const _0x5b063a = {
        id: 'h_paleto_outsidekeypad',
        label: 'Activate',
        icon: _0x58d72f,
        NPXEvent: 'np-heists:paleto:outsideKeypad',
      }
      const _0x3fbf20 = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_sideoutsidekeypad',
        [_0x5b063a],
        {
          distance: _0x3fbf20,
          isEnabled: () => {
            const _0x2ad8ad = _0x2e9b37.g.exports[
              'np-inventory'
            ].hasEnoughOfItem('heistdecrypter_blue', 1, false, true)
            return (
              _0x27316e.isActive &&
              _0x2ad8ad &&
              !_0x27316e.data.openDoors.sideDoor
            )
          },
        }
      )
      const _0x3d1554 = {
        x: -101.91,
        y: 6462.86,
        z: 31.63,
      }
      const _0x391632 = {
        heading: 226,
        minZ: 31.73,
        maxZ: 32.48,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_vaultkeypad',
        _0x3d1554,
        0.2,
        0.6,
        _0x391632
      )
      const _0x4f21de = {
        id: 'h_paleto_vaultkeypad',
        label: 'Enter Code',
        icon: 'envelope-open-text',
        NPXEvent: 'np-heists:paleto:vaultKeypad',
      }
      const _0x142d6b = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget('heist_paleto_vaultkeypad', [_0x4f21de], {
        distance: _0x142d6b,
        isEnabled: () => {
          const _0x531a0a = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'heistlaptop2',
            1,
            false,
            true
          )
          return (
            _0x27316e.isActive && _0x531a0a && !_0x27316e.data.vaultDoorOpen
          )
        },
      })
      const _0x4f4b86 = {
        x: -96.84,
        y: 6463.43,
        z: 31.63,
      }
      const _0x5c8f9d = {
        heading: 316,
        minZ: 31.13,
        maxZ: 32.68,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_loot',
        _0x4f4b86,
        0.2,
        2.4,
        _0x5c8f9d
      )
      const _0x532236 = {
        x: -96.43,
        y: 6459.79,
        z: 31.63,
      }
      const _0x5e64cd = {
        heading: 46,
        minZ: 31.13,
        maxZ: 32.68,
      }
      _0x399ff7.addBoxTarget(
        '2',
        'heist_paleto_loot',
        _0x532236,
        0.2,
        2.4,
        _0x5e64cd
      )
      const _0x2be06b = {
        x: -100.13,
        y: 6459.81,
        z: 31.63,
      }
      const _0x376d5e = {
        heading: 136,
        minZ: 31.13,
        maxZ: 32.68,
      }
      _0x399ff7.addBoxTarget(
        '3',
        'heist_paleto_loot',
        _0x2be06b,
        0.2,
        2.4,
        _0x376d5e
      )
      const _0x33a8cd = {
        NPXEvent: 'np-heists:paleto:rob',
        id: 'h_paleto_loot',
        icon: 'th',
        label: 'Rob',
      }
      const _0x1ac19c = { radius: 2.5 }
      _0x1a26f0.addPeekEntryByTarget('heist_paleto_loot', [_0x33a8cd], {
        distance: _0x1ac19c,
        isEnabled: (_0x46523f, _0x3992a1) => {
          var _0x54ce2f
          const _0x503612 =
            (_0x54ce2f = _0x3992a1.zones.heist_paleto_loot) === null ||
            _0x54ce2f === void 0
              ? void 0
              : _0x54ce2f.id
          if (!_0x503612) {
            return false
          }
          const _0x48d4ee = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'heistdrill_blue',
            1,
            false,
            true
          )
          return (
            _0x27316e.isActive &&
            _0x27316e.data.vaultDoorOpen &&
            !_0x27316e.data.robbedLocations[_0x503612] &&
            _0x48d4ee
          )
        },
      })
      const _0x1c45e5 = {
        x: -98.09,
        y: 6466.29,
        z: 31.63,
      }
      const _0x37c842 = {
        heading: 136,
        minZ: 31.33,
        maxZ: 31.68,
      }
      _0x399ff7.addBoxTarget(
        '2',
        'heist_paleto_officepc',
        _0x1c45e5,
        1.4,
        0.6,
        _0x37c842
      )
      const _0x353ba9 = {
        x: -103.7,
        y: 6460.67,
        z: 31.63,
      }
      const _0x3094a2 = {
        heading: 136,
        minZ: 31.33,
        maxZ: 31.68,
      }
      _0x399ff7.addBoxTarget(
        '1',
        'heist_paleto_officepc',
        _0x353ba9,
        1.4,
        0.6,
        _0x3094a2
      )
      const _0x978832 = {
        id: 'h_paleto_officepc',
        label: 'Activate',
        icon: 'laptop',
        NPXEvent: 'np-heists:paleto:officePCTask',
      }
      const _0x2225f7 = { radius: 2.5 }
      const _0x42a5a2 = {
        distance: _0x2225f7,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_officepc',
        [_0x978832],
        _0x42a5a2
      )
      const _0x740ce7 = {
        id: 'h_paleto_sidekeypad',
        label: 'Activate',
        icon: 'keyboard',
        NPXEvent: 'np-heists:paleto:sideKeypadTask',
      }
      const _0xada78 = { radius: 2.5 }
      const _0x466870 = {
        distance: _0xada78,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_sidekeypad',
        [_0x740ce7],
        _0x466870
      )
      const _0x2c5f02 = {
        id: 'h_paleto_hallpower',
        label: 'Activate',
        icon: 'bolt',
        NPXEvent: 'np-heists:paleto:hallPowerTask',
      }
      const _0x5be5ff = { radius: 2.5 }
      const _0x4cd1b1 = {
        distance: _0x5be5ff,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_hallpower',
        [_0x2c5f02],
        _0x4cd1b1
      )
      const _0x5ee56b = {
        id: 'h_paleto_frontdesk',
        label: 'Activate',
        icon: 'window-restore',
        NPXEvent: 'np-heists:paleto:frontDeskTask',
      }
      const _0x2600d1 = { radius: 2.5 }
      const _0x3133af = {
        distance: _0x2600d1,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_frontdesk',
        [_0x5ee56b],
        _0x3133af
      )
      const _0x1aa288 = {
        id: 'h_paleto_payphone',
        label: 'Activate',
        icon: 'phone-square',
        NPXEvent: 'np-heists:paleto:payphoneTask',
      }
      const _0x3701b7 = { radius: 2.5 }
      const _0xc04774 = {
        distance: _0x3701b7,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget(
        'heist_paleto_payphone',
        [_0x1aa288],
        _0xc04774
      )
      const _0x1ba6bc = {
        id: 'h_paleto_atm',
        label: 'Activate',
        icon: 'dollar-sign',
        NPXEvent: 'np-heists:paleto:atmTask',
      }
      const _0x57e2ee = { radius: 2.5 }
      const _0x3a2a3d = {
        distance: _0x57e2ee,
        isEnabled: () => _0x27316e.isActive,
      }
      _0x1a26f0.addPeekEntryByTarget('heist_paleto_atm', [_0x1ba6bc], _0x3a2a3d)
    },
    _0x6e6489 = async (_0x51b115, _0x25dd29, _0x7691aa, _0x4ec80b) => {
      const _0x2070af = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), true)
        ),
        _0x59fa9e = _0x124ede.fromArray([-85.06, 6461.18, 31.51]),
        _0x425fe5 = _0x2070af.getDistance(_0x59fa9e)
      if (_0x425fe5 > 2.5) {
        return
      }
      if (!_0x4c7581 || _0x4c7581.heistActive) {
        emit('DoLongHudText', 'You cant do that at the moment! (Group)', 2)
        return
      }
      const _0x3bbe6a = {
        label: 'Encryption Code',
        name: 'code',
      }
      const _0xfba5b9 = await _0x2e9b37.g.exports['np-ui'].OpenInputMenu(
        [_0x3bbe6a],
        (_0x566882) => _0x566882 && _0x566882.code
      )
      if (!_0xfba5b9) {
        return
      }
      const _0x4b0933 = await _0x349e09.execute(
        'np-heists:paleto:canRob',
        _0xfba5b9.code
      )
      if (!_0x4b0933) {
        emit('DoLongHudText', 'Unavailable', 2)
        return
      }
      emit('inventory:removeItem', 'thermitecharge', 1)
      const _0x352e79 = {
          x: _0x59fa9e.x,
          y: _0x59fa9e.y,
          z: _0x59fa9e.z,
          h: GetEntityHeading(PlayerPedId()),
        },
        _0xc7b00b = _0x109f88('minigames'),
        _0x42f32a = _0x322e53(Object.assign({}, _0xc7b00b.paleto.thermite))
      _0x3cc3fa(_0x352e79, 0, _0x42f32a)
      const _0x236606 = await _0x42f32a
      if (!_0x236606) {
        return
      }
      const _0x291bb1 = { code: _0xfba5b9.code }
      const _0x6febe5 = await _0x349e09.execute(
        'np-heists:startHeist',
        'paleto',
        _0x291bb1
      )
    }
  _0x288d26.onNet('np-heists:paleto:start', (_0x24244d) => {
    _0x27316e.data = _0x24244d
    _0x27316e.start()
  })
  _0x288d26.onNet('np-heists:paleto:stop', () => {
    _0x27316e.stop()
  })
  _0x288d26.onNet('np-heists:paleto:update', (_0x50f680) => {
    _0x27316e.data = _0x50f680
  })
  _0x288d26.on(
    'np-heists:paleto:powerstation',
    async (_0x46023c, _0xdc30fa, _0x4a78ea) => {
      const _0x3b65cf = _0x4a78ea.zones.heist_paleto_powerstation.id,
        _0x430782 = await _0x349e09.execute(
          'np-heists:paleto:power:canUse',
          _0x3b65cf
        )
      if (!_0x430782) {
        emit('DoLongHudText', 'Unavailable', 2)
        return
      }
      emit('inventory:DegenItemType', 35, 'heistelectronickit_blue')
      const _0x12d4e0 = +_0x3b65cf,
        _0x50d197 = _0x109f88('minigames'),
        _0x19d936 = _0x50d197.powerstation['ddr-' + _0x12d4e0],
        _0x1fe100 = await _0xd70562(Object.assign({}, _0x19d936))
      if (!_0x1fe100) {
        const _0x264ad5 = _0x124ede.fromArray(
            GetEntityCoords(PlayerPedId(), true)
          ),
          _0x129c02 = { police: true }
        const _0x2dc7ff = {
          x: _0x264ad5.x,
          y: _0x264ad5.y,
          z: _0x264ad5.z,
        }
        const _0x1676f8 = {
          dispatchCode: '10-100B',
          displayCode: '10-100B',
          skipMapping: false,
          recipientList: _0x129c02,
          isImportant: true,
          playSound: false,
          soundName: 'HighPrioCrime',
          priority: 1,
          origin: _0x2dc7ff,
        }
        emitNet('dispatch:svNotify', _0x1676f8)
        return
      }
      const _0x88fd1f = GetEntityCoords(PlayerPedId(), false),
        _0x16ce70 = await _0x349e09.execute(
          'np-heists:paleto:power:explode',
          _0x3b65cf,
          _0x88fd1f
        )
    }
  )
  _0x288d26.on(
    'np-heists:paleto:backDoor',
    async (_0xbaa1d1, _0x51ec60, _0x4caf0c) => {
      emit('inventory:DegenItemType', 26, 'heistdecrypter_blue')
      const _0x154e56 = { numPoints: 10 }
      const _0x4bec45 = await _0x562cba(_0x154e56)
      if (!_0x4bec45) {
        return
      }
      _0x349e09.execute('np-heists:paleto:door', 'backDoor')
    }
  )
  _0x288d26.on(
    'np-heists:paleto:securityDoor',
    async (_0x3109e1, _0x1654b8, _0x53556f) => {
      emit('inventory:DegenItemType', 26, 'heistdecrypter_blue')
      const _0x1fbfd8 = { numPoints: 10 }
      const _0x265056 = await _0x562cba(_0x1fbfd8)
      if (!_0x265056) {
        return
      }
      _0x349e09.execute('np-heists:paleto:door', 'securityDoor')
    }
  )
  _0x288d26.on(
    'np-heists:paleto:outsideKeypad',
    async (_0x1db87f, _0x3faaf1, _0x45e325) => {
      emit('inventory:DegenItemType', 26, 'heistdecrypter_blue')
      const _0x362b93 = { numPoints: 10 }
      const _0x1051f5 = await _0x562cba(_0x362b93)
      if (!_0x1051f5) {
        return
      }
      _0x349e09.execute('np-heists:paleto:door', 'sideDoor')
    }
  )
  _0x288d26.on(
    'np-heists:paleto:viewSecurityCams',
    (_0x1f0db7, _0x3b7667, _0x51b948) => {
      const _0x4493fa = _0x455b24.filter((_0x13fb8c) =>
          _0x13fb8c.id.startsWith('paleto')
        ),
        _0x3e3d9e = _0x4493fa.map((_0x36d036) => {
          const _0x561361 = {}
          return (
            (_0x561361.title = _0x36d036.name),
            (_0x561361.icon = 'video'),
            (_0x561361.key = _0x36d036.id),
            (_0x561361.action = 'np-heists:paleto:viewSecurityCam'),
            _0x561361
          )
        })
      _0x2e9b37.g.exports['np-ui'].showContextMenu(_0x3e3d9e)
    }
  )
  RegisterUICallback(
    'np-heists:paleto:viewSecurityCam',
    (_0x1ea2ee, _0x2c4f9d) => {
      const _0x266f92 = {
        ok: true,
        message: '',
      }
      const _0x43e57c = {
        data: {},
        meta: _0x266f92,
      }
      _0x2c4f9d(_0x43e57c)
      const _0x35c6c0 = _0x455b24.find(
        (_0x17452a) => _0x17452a.id === _0x1ea2ee.key
      )
      if (!_0x35c6c0) {
        return
      }
      _0x368943(_0x35c6c0, (_0x4077fe) => {
        const _0x30e3b5 =
          _0x2e9b37.g.exports['np-objects'].GetObjectByEntity(_0x4077fe)
        if (!_0x30e3b5) {
          return false
        }
        const _0x145aa3 = _0x30e3b5.data.metadata
        if (!_0x145aa3.heist_paleto_server) {
          return false
        }
        const _0x10271f = _0x27316e.data.officeData[_0x145aa3.id]
        if (!_0x10271f) {
          return
        }
        const _0x3ddad9 = _0x10271f.locked
          ? '~r~Encrypted!'
          : _0x10271f.current === _0x10271f.target
          ? '~g~' + _0x10271f.code
          : '~r~' + _0x10271f.current + '~w~ / ~g~' + _0x10271f.target
        return (
          _0x273abc(
            0.5,
            0.33,
            _0x3ddad9,
            [0, 0, 0, 255],
            0.4,
            _0x10271f.locked ? 3 : 8,
            0
          ),
          true
        )
      })
    }
  )
  _0x288d26.on(
    'np-heists:paleto:safeCrack',
    async (_0x7560a7, _0x57e3d3, _0x5c5a3b) => {
      const _0x41fee6 = await _0x35679b(3)
      if (!_0x41fee6) {
        return
      }
      const _0x28f8ae = {}
      _0x28f8ae['_factory'] = true
      _0x28f8ae['_description'] =
        'Vault Security Code: ' + _0x27316e.data.vaultKeypadCode
      emit(
        'player:receiveItem',
        'heistsafecodes',
        1,
        false,
        {},
        JSON.stringify(_0x28f8ae)
      )
    }
  )
  _0x288d26.on(
    'np-heists:paleto:vaultKeypad',
    async (_0x5646fd, _0x1fe208, _0x2c08bf) => {
      const _0x2e267f = {
        label: 'Security Code',
        icon: 'code',
        name: 'code',
      }
      const _0x5d40c9 = await _0x2e9b37.g.exports['np-ui'].OpenInputMenu(
        [_0x2e267f],
        (_0x57dc6b) => _0x57dc6b && _0x57dc6b.code
      )
      if (!_0x5d40c9) {
        return
      }
      await _0x4547b9(1)
      if (_0x5d40c9.code !== _0x27316e.data.vaultKeypadCode) {
        emit('DoLongHudText', 'Incorrect Code', 2)
        return
      }
      emit('inventory:DegenItemType', 33, 'heistlaptop2')
      const _0x59735b = _0x109f88('minigames'),
        _0x57e8ef = _0x28bca6(Object.assign({}, _0x59735b.paleto.laptop)),
        _0x5dcf89 = GetEntityCoords(PlayerPedId(), true)
      _0x57a4f3(_0x5dcf89, 225, _0x57e8ef)
      const _0x23c526 = await _0x57e8ef
      if (!_0x23c526) {
        return
      }
      emit('inventory:DegenItemType', 100, 'heistlaptop2')
      await _0x349e09.execute('np-heists:paleto:vaultKeypad')
    }
  )
  _0x288d26.on(
    'np-heists:paleto:rob',
    async (_0x45105c, _0x1700f0, _0x361d07) => {
      var _0x20a8f1
      const _0x2c5d31 =
        (_0x20a8f1 = _0x361d07.zones.heist_paleto_loot) === null ||
        _0x20a8f1 === void 0
          ? void 0
          : _0x20a8f1.id
      if (!_0x2c5d31) {
        return
      }
      _0x288d26.emitNet('np-heists:paleto:startRob', _0x2c5d31)
      emit('inventory:DegenItemType', 26, 'heistdrill_blue')
      const _0x79a2b7 = _0x109f88('minigames'),
        _0x5022b8 = await _0x1fae28(Object.assign({}, _0x79a2b7.paleto.flip))
      await _0x4547b9(1000)
      _0x2e9b37.g.exports['np-ui'].closeApplication('minigame-flip')
      let _0x12fe3e = false
      if (_0x5022b8) {
        const _0x354c54 = _0x1e81a8()
        _0x54843e(_0x354c54)
        _0x12fe3e = await _0x354c54
      }
      const _0x367d70 = await _0x349e09.execute(
        'np-heists:paleto:rob',
        _0x2c5d31,
        _0x12fe3e && _0x5022b8
      )
    }
  )
  _0x288d26.on(
    'np-heists:paleto:doorControl',
    async (_0xf8aaf7, _0x485285, _0xcea1c6) => {
      const _0xcb0afd = {
        id: 'office_1',
        name: 'Office 1',
      }
      const _0x566600 = {
        id: 'office_2',
        name: 'Office 2',
      }
      const _0x1b8138 = {
        id: 'office_3',
        name: 'Office 3',
      }
      const _0x36874d = {
        id: 'lobbyBackDoor',
        name: 'Back Hallway',
      }
      const _0x4af254 = {
        id: 'lobbyMainDesk',
        name: 'Front Desk',
      }
      const _0x7b7ea8 = {
        id: 'lobbySideDoor',
        name: 'Side Hallway',
      }
      const _0x259980 = [
          _0xcb0afd,
          _0x566600,
          _0x1b8138,
          _0x36874d,
          _0x4af254,
          _0x7b7ea8,
        ],
        _0x5173f5 = _0x259980.map((_0x4b6a37) => {
          const _0x130d4d = {}
          return (
            (_0x130d4d.title = _0x4b6a37.name),
            (_0x130d4d.icon = 'key'),
            (_0x130d4d.key = _0x4b6a37.id),
            (_0x130d4d.action = 'np-heists:paleto:door'),
            (_0x130d4d.disabled = _0x27316e.data.openDoors[_0x4b6a37.id]),
            _0x130d4d
          )
        })
      _0x2e9b37.g.exports['np-ui'].showContextMenu(_0x5173f5)
    }
  )
  RegisterUICallback('np-heists:paleto:door', async (_0x3aac48, _0x7454e) => {
    const _0x509a6f = {
      ok: true,
      message: '',
    }
    const _0x504360 = {
      data: {},
      meta: _0x509a6f,
    }
    _0x7454e(_0x504360)
    const _0x3b48f1 = _0x3aac48.key
    if (!_0x3b48f1) {
      return
    }
    await _0x4547b9(1)
    if (_0x3b48f1.startsWith('office')) {
      const _0x4966e3 = {
        label: 'Unlock Code',
        name: 'code',
      }
      const _0x31cd2e = await _0x2e9b37.g.exports['np-ui'].OpenInputMenu(
        [_0x4966e3],
        (_0xe763ae) => _0xe763ae && _0xe763ae.code
      )
      if (!_0x31cd2e) {
        return
      }
      if (_0x31cd2e.code !== _0x27316e.data.officeData[_0x3b48f1].code) {
        emit('DoLongHudText', 'Incorrect Code', 2)
        return
      }
    }
    await _0x349e09.execute('np-heists:paleto:door', _0x3b48f1)
  })
  onNet('np-heists:paleto:power:exploded', async (_0x1e94cf, _0x2139c0) => {
    await _0x54cae9.loadNamedPtfxAsset(_0xa27777)
    UseParticleFxAssetNextCall(_0xa27777)
    SetPtfxAssetNextCall(_0xa27777)
    StartParticleFxLoopedAtCoord(
      _0x4937a9,
      _0x2139c0[0],
      _0x2139c0[1],
      _0x2139c0[2],
      0,
      180,
      0,
      10,
      false,
      false,
      false,
      false
    )
  })
  const _0x9519f6 = () => {
    const _0x59340f = {
      x: 227.86,
      y: 228.45,
      z: 97.5,
    }
    const _0xc179cf = {
      heading: 160,
      minZ: 97.09,
      maxZ: 98.09,
    }
    _0x399ff7.addBoxTarget(
      '1',
      'vault_l_inner_keypad',
      _0x59340f,
      0.3,
      0.8,
      _0xc179cf
    )
    const _0x1e41f0 = {
      x: 229.19,
      y: 231.75,
      z: 96.94,
    }
    const _0x4e035f = {
      heading: 249,
      minZ: 96.94,
      maxZ: 97.34,
    }
    _0x399ff7.addBoxTarget(
      '1',
      'vault_l_inner_desk',
      _0x1e41f0,
      0.9,
      2,
      _0x4e035f
    )
    const _0x32dbeb = {
      x: 225.82,
      y: 230.9,
      z: 97.12,
    }
    const _0xc74736 = {
      heading: 340,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('1', 'vault_rob_loc', _0x32dbeb, 2.4, 0.6, _0xc74736)
    const _0x10d88e = {
      x: 227.13,
      y: 234.67,
      z: 97.12,
    }
    const _0x58d257 = {
      heading: 340,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('2', 'vault_rob_loc', _0x10d88e, 2.4, 0.6, _0x58d257)
    const _0x13c115 = {
      x: 241.03,
      y: 215.7,
      z: 97.12,
    }
    const _0x33cc6e = {
      heading: 340,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('3', 'vault_rob_loc', _0x13c115, 2.4, 0.6, _0x33cc6e)
    const _0x514bb6 = {
      x: 239.89,
      y: 212.72,
      z: 97.12,
    }
    const _0x558232 = {
      heading: 340,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('4', 'vault_rob_loc', _0x514bb6, 2.4, 0.6, _0x558232)
    const _0x1d5793 = {
      x: 241.31,
      y: 209.78,
      z: 97.12,
    }
    const _0x2155d9 = {
      heading: 70,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('5', 'vault_rob_loc', _0x1d5793, 2.4, 0.6, _0x2155d9)
    const _0x2e2f9a = {
      x: 244.44,
      y: 211.07,
      z: 97.12,
    }
    const _0x277507 = {
      heading: 160,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('6', 'vault_rob_loc', _0x2e2f9a, 2.4, 0.6, _0x277507)
    const _0x520633 = {
      x: 245.5,
      y: 213.87,
      z: 97.12,
    }
    const _0x1ddb4a = {
      heading: 160,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('7', 'vault_rob_loc', _0x520633, 2.4, 0.6, _0x1ddb4a)
    const _0x1602f6 = {
      x: 248.51,
      y: 236.53,
      z: 97.12,
    }
    const _0x1a7f70 = {
      heading: 160,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('8', 'vault_rob_loc', _0x1602f6, 2.4, 0.6, _0x1a7f70)
    const _0x291175 = {
      x: 249.62,
      y: 239.16,
      z: 97.12,
    }
    const _0x30b481 = {
      heading: 160,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('9', 'vault_rob_loc', _0x291175, 2.4, 0.6, _0x30b481)
    const _0x310aba = {
      x: 253.95,
      y: 237.76,
      z: 97.12,
    }
    const _0x2dbad8 = {
      heading: 160,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget(
      '10',
      'vault_rob_loc',
      _0x310aba,
      2.4,
      0.6,
      _0x2dbad8
    )
    const _0x5958e0 = {
      x: 253.16,
      y: 235.29,
      z: 97.12,
    }
    const _0x3ba6e6 = {
      heading: 160,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget(
      '11',
      'vault_rob_loc',
      _0x5958e0,
      2.4,
      0.6,
      _0x3ba6e6
    )
    const _0x409360 = {
      x: 252.56,
      y: 240.81,
      z: 97.12,
    }
    const _0xc8b15 = {
      heading: 250,
      minZ: 96.72,
      maxZ: 99.32,
    }
    _0x399ff7.addBoxTarget('12', 'vault_rob_loc', _0x409360, 2.4, 0.6, _0xc8b15)
    const _0xf8fb2e = {
      x: 269.75,
      y: 223.7,
      z: 96.94,
    }
    const _0x57c9b0 = {
      heading: 250,
      minZ: 96.94,
      maxZ: 97.34,
    }
    _0x399ff7.addBoxTarget(
      '1',
      'vault_loot_keycard',
      _0xf8fb2e,
      1,
      1.7,
      _0x57c9b0
    )
    const _0x44e4af = {
      NPXEvent: 'np-heists:vault:rob',
      id: 'vault_rob_drill',
      icon: 'th',
      label: 'Rob',
    }
    const _0x3c0ab0 = { radius: 2.5 }
    _0x1a26f0.addPeekEntryByTarget('vault_rob_loc', [_0x44e4af], {
      distance: _0x3c0ab0,
      isEnabled: (_0x1295d5, _0x2b4e61) => {
        var _0x125f8c
        const _0x2127b6 =
          (_0x125f8c = _0x2b4e61.zones.vault_rob_loc) === null ||
          _0x125f8c === void 0
            ? void 0
            : _0x125f8c.id
        if (!_0x2127b6) {
          return false
        }
        const _0x70f591 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistdrill_red',
          1,
          false,
          true
        )
        return (
          _0x29d825.isActive &&
          !_0x29d825.data.robbedLocations[_0x2127b6] &&
          _0x70f591
        )
      },
    })
    const _0x394cba = { doorId: 1112 }
    const _0x33a2af = {
      NPXEvent: 'np-heists:vault:lootKeycard',
      id: 'vault_l_inner_keycard1',
      icon: 'circle',
      label: 'Pickup Left Keycard',
      parameters: _0x394cba,
    }
    const _0x4ca3bc = { doorId: 1113 }
    const _0x24890d = {
      NPXEvent: 'np-heists:vault:lootKeycard',
      id: 'vault_l_inner_keycard2',
      icon: 'circle',
      label: 'Pickup Right Keycard',
      parameters: _0x4ca3bc,
    }
    const _0x26e678 = { radius: 2.5 }
    const _0x1fb77a = {
      distance: _0x26e678,
      isEnabled: (_0x2b6858, _0x10ba24) => {
        return _0x29d825.isActive && !_0x29d825.data.keycardPickedUp
      },
    }
    _0x1a26f0.addPeekEntryByTarget(
      'vault_loot_keycard',
      [_0x33a2af, _0x24890d],
      _0x1fb77a
    )
    const _0x558669 = {
      NPXEvent: 'np-heists:vault:lootKeypad',
      id: 'vault_l_inner_keypad',
      icon: 'credit-card',
      label: 'Use Keycard',
    }
    const _0x3a1c20 = { radius: 2.5 }
    _0x1a26f0.addPeekEntryByTarget('vault_l_inner_keypad', [_0x558669], {
      distance: _0x3a1c20,
      isEnabled: (_0xa5ca63, _0x5a963b) => {
        const _0x1896af = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistkeycard_vault',
          1,
          false,
          true
        )
        return _0x29d825.isActive && !_0x29d825.data.keycardUsed && _0x1896af
      },
    })
    const _0x1cd9a0 = {
      NPXEvent: 'np-heists:vault:lootDesk',
      id: 'vault_l_inner_desk',
      icon: 'circle',
      label: 'Search',
    }
    const _0x3a55ce = { radius: 2.5 }
    const _0x461b77 = {
      distance: _0x3a55ce,
      isEnabled: (_0x1b708b, _0x90efc5) => {
        return _0x29d825.isActive && !_0x29d825.data.vaultDeskSearched
      },
    }
    _0x1a26f0.addPeekEntryByTarget('vault_l_inner_desk', [_0x1cd9a0], _0x461b77)
    const _0x5428cc = _0x2f22a1('np-heists:vault', 'robObjects'),
      _0x1fd5f8 = {
        id: 'vault_steal_trolley',
        icon: 'hand-holding',
        label: 'Take',
        NPXEvent: 'np-heists:vault:steal',
      }
    const _0x12b842 = { radius: 2.5 }
    _0x1a26f0.addPeekEntryByModel(
      _0x5428cc.map((_0x3e5bfc) => GetHashKey(_0x3e5bfc.model)),
      [_0x1fd5f8],
      {
        distance: _0x12b842,
        isEnabled: (_0x2a5b58, _0x51a168) => {
          var _0x38495c, _0x13b8dc, _0xeb291d
          const _0x10f4c7 =
            (_0xeb291d =
              (_0x13b8dc =
                (_0x38495c = _0x51a168.meta) === null || _0x38495c === void 0
                  ? void 0
                  : _0x38495c.data) === null || _0x13b8dc === void 0
                ? void 0
                : _0x13b8dc.metadata) === null || _0xeb291d === void 0
              ? void 0
              : _0xeb291d.heistLoot
          return _0x10f4c7
        },
      }
    )
  }
  _0x288d26.on(
    'np-heists:vault:rob',
    async (_0x3e616c, _0x2eaa53, _0x5c8d72) => {
      var _0x1275bc
      const _0x784147 =
        (_0x1275bc = _0x5c8d72.zones.vault_rob_loc) === null ||
        _0x1275bc === void 0
          ? void 0
          : _0x1275bc.id
      if (!_0x784147) {
        return
      }
      _0x288d26.emitNet('np-heists:vault:startRob', _0x784147)
      emit('inventory:DegenItemType', 26, 'heistdrill_red')
      const _0x5293d7 = _0x109f88('minigames'),
        _0x25117c = await _0x1fae28(Object.assign({}, _0x5293d7.vault.flip))
      await _0x4547b9(1000)
      _0x2e9b37.g.exports['np-ui'].closeApplication('minigame-flip')
      let _0x278e63 = false
      if (_0x25117c) {
        const _0x66592d = _0x1e81a8()
        _0x54843e(_0x66592d)
        _0x278e63 = await _0x66592d
      }
      const _0x54352e = await _0x349e09.execute(
        'np-heists:vault:rob',
        _0x784147,
        _0x278e63 && _0x25117c
      )
    }
  )
  _0x288d26.on('np-heists:vault:steal', (_0x393936, _0x5c1145, _0x33b553) => {
    const _0x2e633d = _0x33b553.meta
    if (!_0x2e633d) {
      return
    }
    _0x349e09.execute('np-heists:vault:stealObject', _0x2e633d)
  })
  _0x288d26.on(
    'np-heists:vault:lootKeycard',
    (_0x18426f, _0x2da0fa, _0x2e7a82) => {
      const _0x1b6baf = _0x18426f.doorId
      _0x349e09.execute('np-heists:vault:lootKeycard', _0x1b6baf)
    }
  )
  _0x288d26.on(
    'np-heists:vault:lootKeypad',
    (_0x11d284, _0x1e90bc, _0x33643f) => {
      const _0x59a629 = _0x2e9b37.g.exports['np-inventory'].getItemsOfType(
        'heistkeycard_vault',
        1,
        true
      )
      if (!_0x59a629 || !_0x59a629[0]) {
        return
      }
      const _0x5b854e = JSON.parse(_0x59a629[0].information),
        _0x375578 = _0x5b854e.EncryptionKey
      if (!_0x375578) {
        return
      }
      _0x349e09.execute('np-heists:vault:lootKeypad', _0x375578)
    }
  )
  _0x288d26.on('np-heists:vault:lootDesk', () => {
    _0x349e09.execute('np-heists:vault:lootDesk')
  })
  const _0x3ac72a = new Map(),
    _0x22539f = async () => {
      _0x399ff7.onEnter('heists_door_handler', async (_0x557945) => {
        const _0x5f4ed6 = _0x3ac72a.get(_0x557945.id)
        if (!_0x5f4ed6) {
          return
        }
        _0x368c45(_0x5f4ed6)
      })
      const _0x194b48 = await _0x349e09.execute('np-heists:doors:getState')
      for (const _0x80887f of _0x194b48) {
        _0x441b79(_0x80887f)
      }
    },
    _0x368c45 = async (_0x36a97c) => {
      const _0xc46905 = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), false)
        ),
        _0x13b8f9 = _0x124ede.fromArray(_0x36a97c.coords)
      if (_0xc46905.getDistance(_0x13b8f9) > 400) {
        return
      }
      let _0x3b20d8
      const _0x207342 = await _0x5ae501.waitForCondition(() => {
        return (
          (_0x3b20d8 = GetClosestObjectOfType(
            _0x36a97c.coords[0],
            _0x36a97c.coords[1],
            _0x36a97c.coords[2],
            5,
            _0x36a97c.hash,
            false,
            false,
            false
          )),
          _0x3b20d8 && DoesEntityExist(_0x3b20d8)
        )
      }, 30000)
      if (_0x207342) {
        return
      }
      _0x4e9f3c(
        _0x3b20d8,
        _0x36a97c.isOpen ? _0x36a97c.headingOpen : _0x36a97c.headingClosed
      )
    },
    _0x332251 = (_0x59e6b3) => {
      _0x399ff7.addBoxZone(
        _0x59e6b3.id,
        'heists_door_handler',
        {
          x: _0x59e6b3.coords[0],
          y: _0x59e6b3.coords[1],
          z: _0x59e6b3.coords[2],
        },
        50,
        50,
        {
          minZ: _0x59e6b3.coords[2] - 30,
          maxZ: _0x59e6b3.coords[2] + 30,
        }
      )
    },
    _0x441b79 = (_0x2678e3) => {
      !_0x3ac72a.has(_0x2678e3.id) && _0x332251(_0x2678e3)
      _0x3ac72a.set(_0x2678e3.id, _0x2678e3)
      _0x368c45(_0x2678e3)
    }
  _0x288d26.onNet('np-heists:doors:set', _0x441b79)
  let _0x46d6bb = true
  const _0x5b288c = () => {
    const _0x12be3b = {
      x: 249.76,
      y: 224.18,
      z: 97.13,
    }
    const _0x3c6769 = {
      heading: 339,
      minZ: 96.13,
      maxZ: 100.13,
    }
    _0x399ff7.addBoxZone(
      '1',
      'vault_lower_lasers',
      _0x12be3b,
      33.4,
      50,
      _0x3c6769
    )
    const _0xd6123e = {
      x: 267.69,
      y: 213.13,
      z: 97.12,
    }
    const _0x293795 = {
      heading: 71,
      minZ: 97.12,
      maxZ: 98.12,
    }
    const _0x1c20e6 = { doorId: 1105 }
    _0x399ff7.addBoxTarget(
      '1',
      'vault_syncpad',
      _0xd6123e,
      0.4,
      0.7,
      _0x293795,
      _0x1c20e6
    )
    const _0x40a992 = {
      x: 270.64,
      y: 221.22,
      z: 97.12,
    }
    const _0x53bc27 = {
      heading: 69,
      minZ: 97.12,
      maxZ: 98.12,
    }
    const _0x7c47f6 = { doorId: 1104 }
    _0x399ff7.addBoxTarget(
      '2',
      'vault_syncpad',
      _0x40a992,
      0.5,
      0.8,
      _0x53bc27,
      _0x7c47f6
    )
    const _0x22dca0 = {
      x: 241.86,
      y: 218.66,
      z: 97.12,
    }
    const _0x586623 = {
      heading: 160,
      minZ: 97.12,
      maxZ: 98.12,
    }
    const _0x39ff49 = { doorId: 1109 }
    _0x399ff7.addBoxTarget(
      '1',
      'vault_l_side_keypad',
      _0x22dca0,
      0.5,
      0.9,
      _0x586623,
      _0x39ff49
    )
    const _0x52ccf9 = {
      x: 247.32,
      y: 233.75,
      z: 97.12,
    }
    const _0x28d020 = {
      heading: 340,
      minZ: 97.12,
      maxZ: 98.12,
    }
    const _0x27c1a1 = { doorId: 1110 }
    _0x399ff7.addBoxTarget(
      '2',
      'vault_l_side_keypad',
      _0x52ccf9,
      0.5,
      0.9,
      _0x28d020,
      _0x27c1a1
    )
    const _0x2b1063 = {
      x: 236.4,
      y: 231.76,
      z: 97.62,
    }
    const _0x19f27f = {
      heading: 70,
      minZ: 97.12,
      maxZ: 98.12,
    }
    _0x399ff7.addBoxTarget(
      '1',
      'vault_l_keypad_vault',
      _0x2b1063,
      0.5,
      0.7,
      _0x19f27f
    )
    const _0xa0f147 = {
      x: 259.96,
      y: 213.15,
      z: 97.12,
    }
    const _0x154605 = {
      heading: 340,
      minZ: 97.52,
      maxZ: 99.22,
    }
    _0x399ff7.addBoxZone('1', 'vault_laser_box', _0xa0f147, 1.6, 1.8, _0x154605)
    const _0x3a76a7 = {
      x: 260.5,
      y: 213.15,
      z: 98.72,
    }
    const _0x3c6409 = {
      heading: 340,
      minZ: 97.52,
      maxZ: 99.22,
    }
    _0x399ff7.addBoxTarget(
      '2',
      'placeholder_target',
      _0x3a76a7,
      0.1,
      0.1,
      _0x3c6409
    )
    const _0x3e2243 = {
      id: 'vault_l_power_box_peek',
      label: 'Activate',
      icon: _0x38020f,
      NPXEvent: 'np-heists:vault:lowerPowerBox',
    }
    const _0x4fd8e7 = { radius: 2 }
    _0x1a26f0.addPeekEntryByTarget('vault_laser_box', [_0x3e2243], {
      distance: _0x4fd8e7,
      isEnabled: (_0x56c2e6, _0x25cf89) => {
        const _0x1a1024 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistelectronickit_red',
          1,
          false,
          true
        )
        return _0x29d825.isActive && _0x46d6bb && _0x1a1024
      },
    })
    const _0x2595e1 = {
      id: 'vault_l_keypad_vault',
      label: 'Hack',
      icon: _0x989475,
      NPXEvent: 'np-heists:vault:lowerKeypadVault',
    }
    const _0x217bf1 = { radius: 4 }
    _0x1a26f0.addPeekEntryByTarget('vault_l_keypad_vault', [_0x2595e1], {
      distance: _0x217bf1,
      isEnabled: (_0x46854b, _0x290812) => {
        return (
          _0x29d825.isActive &&
          !_0x46d6bb &&
          !_0x29d825.data.doorHacked &&
          (!_0x3ac72a.has('vault_lower_door') ||
            !_0x3ac72a.get('vault_lower_door').isOpen)
        )
      },
    })
    const _0x1852d4 = {
      id: 'vault_syncpad',
      label: 'Hack',
      icon: _0x58d72f,
      NPXEvent: 'np-heists:vault:syncPad',
    }
    const _0x1e138a = { radius: 4 }
    _0x1a26f0.addPeekEntryByTarget('vault_syncpad', [_0x1852d4], {
      distance: _0x1e138a,
      isEnabled: (_0xce8f71, _0x3349e0) => {
        var _0x67b826
        const _0x55f3c9 =
            (_0x67b826 = _0x3349e0.zones.vault_syncpad) === null ||
            _0x67b826 === void 0
              ? void 0
              : _0x67b826.id,
          _0x14a18c = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'heistdecrypter_red',
            1,
            false,
            true
          )
        return (
          _0x29d825.isActive &&
          _0x55f3c9 &&
          _0x14a18c &&
          _0x29d825.data.stairCaseOpen &&
          !_0x29d825.data.syncPads[_0x55f3c9] &&
          !_0x29d825.data.lowerOpened
        )
      },
    })
    const _0x347f89 = {
      id: 'vault_l_side_keypad',
      label: 'Hack',
      icon: _0x58d72f,
      NPXEvent: 'np-heists:vault:lowerSideKeypad',
    }
    const _0x5e50ad = { radius: 4 }
    _0x1a26f0.addPeekEntryByTarget('vault_l_side_keypad', [_0x347f89], {
      distance: _0x5e50ad,
      isEnabled: (_0x4fc977, _0x38185e) => {
        var _0x5e6ddf
        const _0x309c97 =
            (_0x5e6ddf = _0x38185e.zones.vault_l_side_keypad) === null ||
            _0x5e6ddf === void 0
              ? void 0
              : _0x5e6ddf.id,
          _0x44af56 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'heistdecrypter_red',
            1,
            false,
            true
          )
        return (
          _0x29d825.isActive &&
          _0x309c97 &&
          !_0x46d6bb &&
          _0x44af56 &&
          !_0x29d825.data.lowerSideKeypads[_0x309c97]
        )
      },
    })
    const _0x543915 = {
      id: 'heist_vault_l_drill',
      label: 'Drill',
      icon: _0xef3fa4,
      NPXEvent: 'np-heists:vault:drillDoor',
    }
    const _0x3e220d = { radius: 4.5 }
    _0x1a26f0.addPeekEntryByModel([961976194], [_0x543915], {
      distance: _0x3e220d,
      isEnabled: (_0x4ae0c1, _0xc92b69) => {
        const _0x5a69eb = _0x2e9b37.g.exports['np-doors'].GetCurrentDoor()
        return (
          _0x29d825.isActive && _0x29d825.data.doorHacked && _0x5a69eb === 1111
        )
      },
    })
    const _0x3437fe = {
      id: 'heist_pickup_box',
      label: 'Pickup',
      icon: 'box',
      NPXEvent: 'np-heists:vault:pickupBox',
    }
    const _0x40d230 = { radius: 2.5 }
    const _0x4e9076 = {
      distance: _0x40d230,
      isEnabled: (_0x25ad58, _0x543bf7) => {
        return !!_0x543bf7.meta
      },
    }
    _0x1a26f0.addPeekEntryByModel([377646791], [_0x3437fe], _0x4e9076)
    _0x399ff7.onEnter('vault_lower_lasers', () => {
      if (!_0x46d6bb) {
        return
      }
      RequestScriptAudioBank('DLC_HEIST3\\HEIST_FINALE_LASER_DRILL', false)
      RequestScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL', false)
      RequestScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2', false)
      emit('np-heists:vault:laserState', true)
    })
    _0x399ff7.onExit('vault_lower_lasers', () => {
      ReleaseNamedScriptAudioBank('DLC_HEIST3\\HEIST_FINALE_LASER_DRILL')
      ReleaseNamedScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL')
      ReleaseNamedScriptAudioBank('DLC_MPHEIST\\HEIST_FLEECA_DRILL_2')
      emit('np-heists:vault:laserState', false)
    })
  }
  _0x288d26.on(
    'np-heists:vault:pickupBox',
    async (_0x1bbca8, _0x3ec956, _0x43f83d) => {
      const _0x173dbb = await _0x349e09.execute(
        'np-objects:DeleteObject',
        _0x43f83d.meta.id
      )
      _0x173dbb && emit('player:receiveItem', 'heistbox', 1)
    }
  )
  const _0x16e4df = async (_0x2de624, _0x254cff, _0x28d731, _0x3ece16) => {
    const _0x3c64f2 = {
      collision: true,
      zOffset: 0.25,
      groupSnap: true,
      forceGroupSnap: true,
    }
    const _0x5b4bde = await _0x2e9b37.g.exports[
      'np-objects'
    ].PlaceAndSaveObject(
      'hei_prop_heist_wooden_box',
      {},
      _0x3c64f2,
      () => true,
      'objects',
      3600
    )
    if (!_0x5b4bde) {
      return
    }
    emit('inventory:removeItem', _0x2de624, 1)
  }
  on('np-heists:vault:laserHit', () => {
    _0x288d26.emitNet('np-heists:vault:laserHit')
  })
  onNet('np-heists:vault:laserSound', (_0x4e0473) => {
    PlaySoundFromCoord(
      -1,
      'laser_pin_break',
      _0x4e0473[0],
      _0x4e0473[1],
      _0x4e0473[2],
      'dlc_ch_heist_finale_laser_drill_sounds',
      false,
      25,
      false
    )
  })
  onNet('np-heists:vault:laserTrap', () => {
    PlaySoundFromCoord(
      -1,
      'laser_overheat',
      234.99,
      228.07,
      97.72,
      'dlc_ch_heist_finale_laser_drill_sounds',
      false,
      100,
      false
    )
    PlaySoundFromCoord(
      -1,
      'laser_overheat',
      234.99,
      228.07,
      97.72,
      'dlc_ch_heist_finale_laser_drill_sounds',
      false,
      100,
      false
    )
    PlaySoundFromCoord(
      -1,
      'laser_overheat',
      234.99,
      228.07,
      97.72,
      'dlc_ch_heist_finale_laser_drill_sounds',
      false,
      100,
      false
    )
    PlaySoundFromCoord(
      -1,
      'laser_overheat',
      253.47,
      222.99,
      97.12,
      'dlc_ch_heist_finale_laser_drill_sounds',
      false,
      100,
      false
    )
    PlaySoundFromCoord(
      -1,
      'laser_overheat',
      253.47,
      222.99,
      97.12,
      'dlc_ch_heist_finale_laser_drill_sounds',
      false,
      100,
      false
    )
    PlaySoundFromCoord(
      -1,
      'laser_overheat',
      253.47,
      222.99,
      97.12,
      'dlc_ch_heist_finale_laser_drill_sounds',
      false,
      100,
      false
    )
  })
  _0x288d26.onNet('np-heists:vault:laserState', (_0x529fb5) => {
    _0x46d6bb = _0x529fb5
    _0x399ff7.isActive('vault_lower_lasers') &&
      emit('np-heists:vault:laserState', _0x46d6bb)
  })
  _0x288d26.on('np-heists:vault:lowerPowerBox', async () => {
    if (_0xfb461f) {
      _0x346bf0()
      _0x288d26.emitNet('np-heists:vault:shockPtfx')
      return
    }
    emit('inventory:DegenItemType', 33, 'heistelectronickit_red')
    const _0x3980e4 = _0x109f88('minigames'),
      _0x11aa08 = await _0xd70562(Object.assign({}, _0x3980e4.vault.ddr))
    if (!_0x11aa08) {
      return
    }
    await _0x349e09.execute('np-heists:vault:lowerPowerBoxResult')
  })
  _0x288d26.on('np-heists:vault:lowerKeypadVault', async () => {
    if (_0x29d825.data.laserTrap) {
      _0x346bf0()
      _0x288d26.emitNet('np-heists:vault:shockPtfx')
      emit('DoLongHudText', 'Anti-theft security system tripped', 2)
      return
    }
    emit('inventory:DegenItemType', 33, 'heistlaptop4')
    const _0x47ddf2 = _0x109f88('minigames'),
      _0x19be40 = _0x28bca6(Object.assign({}, _0x47ddf2.vault['laptop-lower'])),
      _0x2b7ee3 = GetEntityCoords(PlayerPedId(), true)
    _0x57a4f3(_0x2b7ee3, 70, _0x19be40)
    const _0x3c8fe2 = await _0x19be40
    if (!_0x3c8fe2) {
      return
    }
    emit('inventory:DegenItemType', 100, 'heistlaptop4')
    await _0x349e09.execute('np-heists:vault:lowerKeypadVaultResult')
  })
  _0x288d26.on('np-heists:vault:drillDoor', async () => {
    const _0x46824b = _0x2e9b37.g.exports['np-doors'].GetCurrentDoor()
    if (_0x46824b !== 1111) {
      return
    }
    const _0x46dbcb = _0x1e81a8()
    _0x54843e(_0x46dbcb)
    const _0x3c6bd6 = await _0x46dbcb
    if (!_0x3c6bd6) {
      return
    }
    _0x288d26.emitNet('np-heists:vault:vaultDoorOpen')
  })
  _0x288d26.on(
    'np-heists:vault:syncPad',
    async (_0x3dc847, _0x41c987, _0x4cf1f1) => {
      var _0x38bdc0, _0x5c4449
      const _0x1c8d90 =
        (_0x38bdc0 = _0x4cf1f1.zones.vault_syncpad) === null ||
        _0x38bdc0 === void 0
          ? void 0
          : _0x38bdc0.id
      if (!_0x1c8d90) {
        return
      }
      const _0x45b447 =
        (_0x5c4449 = _0x4cf1f1.zones.vault_syncpad) === null ||
        _0x5c4449 === void 0
          ? void 0
          : _0x5c4449.doorId
      emit('inventory:DegenItemType', 26, 'heistdecrypter_red')
      _0x288d26.emitNet('np-heists:vault:syncPadStart', _0x1c8d90)
      const _0x239d1d = { numPoints: 10 }
      const _0xe164e3 = await _0x562cba(_0x239d1d)
      _0x349e09.execute(
        'np-heists:vault:syncPadResult',
        _0x1c8d90,
        _0xe164e3,
        _0x45b447
      )
    }
  )
  _0x288d26.on(
    'np-heists:vault:lowerSideKeypad',
    async (_0x5cd906, _0x2f3f46, _0x2b854c) => {
      var _0x142797, _0x5149b8
      const _0x55cf83 =
        (_0x142797 = _0x2b854c.zones.vault_l_side_keypad) === null ||
        _0x142797 === void 0
          ? void 0
          : _0x142797.id
      if (!_0x55cf83) {
        return
      }
      const _0x407ecf =
        (_0x5149b8 = _0x2b854c.zones.vault_l_side_keypad) === null ||
        _0x5149b8 === void 0
          ? void 0
          : _0x5149b8.doorId
      emit('inventory:DegenItemType', 26, 'heistdecrypter_red')
      const _0x230d54 = _0x109f88('minigames'),
        _0x312a43 = await _0x562cba(Object.assign({}, _0x230d54.vault.untangle))
      if (!_0x312a43) {
        return
      }
      _0x349e09.execute(
        'np-heists:vault:lowerSideKeypadResult',
        _0x55cf83,
        _0x407ecf
      )
    }
  )
  onNet('np-heists:vault:shocked', async (_0x13dcf0) => {
    await _0x54cae9.loadNamedPtfxAsset(_0xa27777)
    UseParticleFxAssetNextCall(_0xa27777)
    SetPtfxAssetNextCall(_0xa27777)
    StartParticleFxLoopedAtCoord(
      _0x4937a9,
      _0x13dcf0[0],
      _0x13dcf0[1],
      _0x13dcf0[2],
      0,
      180,
      0,
      2.5,
      false,
      false,
      false,
      false
    )
  })
  const _0x2999f5 = () => {
    const _0x41bd2c = {
      x: 272.27,
      y: 214.91,
      z: 106.28,
    }
    const _0x5af73e = {
      heading: 248,
      minZ: 106.28,
      maxZ: 107.28,
    }
    const _0x4f239c = { doorId: 1129 }
    _0x399ff7.addBoxTarget(
      '1',
      'vault_stairs_keypad',
      _0x41bd2c,
      0.8,
      0.7,
      _0x5af73e,
      _0x4f239c
    )
    const _0x355981 = {
      x: 261.25,
      y: 235.02,
      z: 106.1,
    }
    const _0x1b9946 = {
      heading: 160,
      minZ: 106.1,
      maxZ: 106.6,
    }
    const _0x5505e9 = {
      folders: ['Homework', 'Documents'],
      textFiles: ['prbg', 'harmony_account', 'notes'],
      background: 'https://i.imgur.com/OfaocOd.jpg',
    }
    _0x399ff7.addBoxTarget(
      '1',
      'heist_vault_pc',
      _0x355981,
      1,
      1.7,
      _0x1b9946,
      _0x5505e9
    )
    const _0xb7a864 = {
      x: 270.54,
      y: 231.43,
      z: 106.28,
    }
    const _0x44f6a6 = {
      heading: 70,
      minZ: 106.08,
      maxZ: 106.48,
    }
    const _0x15b5fc = {
      folders: ['Fedora'],
      textFiles: ['resignationletter'],
      background: 'https://i.imgur.com/2MTVm33.png',
    }
    _0x399ff7.addBoxTarget(
      '2',
      'heist_vault_pc',
      _0xb7a864,
      1.8,
      1,
      _0x44f6a6,
      _0x15b5fc
    )
    const _0x5d7c47 = {
      x: 261.08,
      y: 234.84,
      z: 110.17,
    }
    const _0x8d82b6 = {
      heading: 70,
      minZ: 109.97,
      maxZ: 110.37,
    }
    const _0x8700a9 = {
      folders: ['Work', 'SON_DO_NOT_TOUCH'],
      textFiles: ['freegames', 'rambypass'],
      background: 'https://i.imgur.com/p924kQR.png',
    }
    _0x399ff7.addBoxTarget(
      '3',
      'heist_vault_pc',
      _0x5d7c47,
      1.8,
      1,
      _0x8d82b6,
      _0x8700a9
    )
    const _0x16b5b0 = {
      x: 270.52,
      y: 231.44,
      z: 110.17,
    }
    const _0x555258 = {
      heading: 70,
      minZ: 109.97,
      maxZ: 110.37,
    }
    const _0x525b49 = {
      folders: ['Chatterino2.3.5'],
      textFiles: ['mitchaccount', 'pastas'],
      background: 'https://i.imgur.com/ArrXblZ.png',
    }
    _0x399ff7.addBoxTarget(
      '4',
      'heist_vault_pc',
      _0x16b5b0,
      1.8,
      1,
      _0x555258,
      _0x525b49
    )
    const _0x412f73 = {
      x: 251.7,
      y: 208.86,
      z: 106.29,
    }
    const _0x319d89 = {
      heading: 70,
      minZ: 106.09,
      maxZ: 106.49,
    }
    const _0x1710bd = {
      folders: ['CodeWalker'],
      textFiles: ['gta_debug_strings'],
      background: 'https://i.imgur.com/pSGS1fw.jpg',
    }
    _0x399ff7.addBoxTarget(
      '5',
      'heist_vault_pc',
      _0x412f73,
      1.8,
      1,
      _0x319d89,
      _0x1710bd
    )
    const _0x250905 = {
      x: 261.09,
      y: 205.47,
      z: 106.28,
    }
    const _0x90d9cd = {
      heading: 70,
      minZ: 106.08,
      maxZ: 106.48,
    }
    const _0x1f9031 = {
      folders: ['Orion2', 'ms2code'],
      textFiles: ['github_acc'],
      whiteIconNames: 'off',
      background: 'https://i.imgur.com/FxnFhTQ.png',
    }
    _0x399ff7.addBoxTarget(
      '6',
      'heist_vault_pc',
      _0x250905,
      1.8,
      1,
      _0x90d9cd,
      _0x1f9031
    )
    const _0x215301 = {
      x: 251.7,
      y: 208.84,
      z: 110.17,
    }
    const _0x5bd4df = {
      heading: 70,
      minZ: 109.97,
      maxZ: 110.37,
    }
    const _0x5154f3 = {
      folders: ['important'],
      textFiles: ['do_not_lose'],
      background: 'https://i.imgur.com/EEwTSk1.jpg',
    }
    _0x399ff7.addBoxTarget(
      '7',
      'heist_vault_pc',
      _0x215301,
      1.8,
      1,
      _0x5bd4df,
      _0x5154f3
    )
    const _0x2ba6cf = {
      x: 261.11,
      y: 205.43,
      z: 110.17,
    }
    const _0x270835 = {
      heading: 70,
      minZ: 109.97,
      maxZ: 110.37,
    }
    const _0x5db24e = {
      folders: ['ElectronApp'],
      textFiles: ['work_app_notes', 'daughter_wedding'],
      background: 'https://i.imgur.com/8Lthbn7.png',
    }
    _0x399ff7.addBoxTarget(
      '8',
      'heist_vault_pc',
      _0x2ba6cf,
      1.8,
      1,
      _0x270835,
      _0x5db24e
    )
    const _0x4864c2 = {
      x: 279.14,
      y: 213.52,
      z: 110.17,
    }
    const _0x501fd9 = {
      heading: 160,
      minZ: 109.97,
      maxZ: 110.37,
    }
    _0x399ff7.addBoxTarget(
      '1',
      'heist_vault_pc_ceo',
      _0x4864c2,
      1.8,
      1,
      _0x501fd9
    )
    const _0x57610f = {
      x: 278.73,
      y: 217.47,
      z: 109.17,
    }
    const _0x13d4ae = {
      heading: 70,
      minZ: 109.17,
      maxZ: 111.17,
    }
    _0x399ff7.addBoxTarget(
      '1',
      'heist_vault_safe_ceo',
      _0x57610f,
      1.1,
      0.3,
      _0x13d4ae
    )
    const _0x25f8be = {
      x: 272.04,
      y: 214.35,
      z: 109.97,
    }
    const _0x208fac = {
      heading: 250,
      minZ: 109.97,
      maxZ: 110.97,
    }
    _0x399ff7.addBoxTarget(
      '1',
      'heist_vault_door_ceo',
      _0x25f8be,
      0.3,
      0.7,
      _0x208fac
    )
    const _0x5338ee = {
      x: 249.72,
      y: 218.19,
      z: 106.28,
    }
    const _0x343831 = {
      heading: 340,
      minZ: 105.28,
      maxZ: 107.68,
    }
    const _0x133aad = { doorId: 1127 }
    _0x399ff7.addBoxZone(
      '1',
      'heist_vault_cagedoor',
      _0x5338ee,
      1.2,
      1.4,
      _0x343831,
      _0x133aad
    )
    const _0x470d01 = {
      x: 253.75,
      y: 228.89,
      z: 106.28,
    }
    const _0x36e9c4 = {
      heading: 340,
      minZ: 105.28,
      maxZ: 107.68,
    }
    const _0xc24488 = { doorId: 1128 }
    _0x399ff7.addBoxZone(
      '2',
      'heist_vault_cagedoor',
      _0x470d01,
      1.2,
      1.4,
      _0x36e9c4,
      _0xc24488
    )
    const _0x5c5c6d = {
      id: 'heist_vault_cagedoor',
      label: 'Unlock',
      icon: _0xa52546,
      NPXEvent: 'np-heists:vault:upperCageDoor',
    }
    const _0x5359e3 = { radius: 4 }
    _0x1a26f0.addPeekEntryByTarget('heist_vault_cagedoor', [_0x5c5c6d], {
      distance: _0x5359e3,
      isEnabled: (_0x5190ab, _0x4c76f5) => {
        var _0x4432af
        const _0x3edfd0 =
            (_0x4432af = _0x4c76f5.zones.heist_vault_cagedoor) === null ||
            _0x4432af === void 0
              ? void 0
              : _0x4432af.id,
          _0x56fe95 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
            'thermitecharge',
            1,
            false,
            true
          )
        return (
          _0x29d825.isActive &&
          _0x3edfd0 &&
          !_0x29d825.data.cageDoorOpen[_0x3edfd0] &&
          _0x56fe95
        )
      },
    })
    const _0x69079e = {
      id: 'vault_upper_keypad',
      label: 'Hack',
      icon: _0x989475,
      NPXEvent: 'np-heists:vault:upperKeypad',
    }
    const _0x3661e = { radius: 4 }
    _0x1a26f0.addPeekEntryByTarget('vault_stairs_keypad', [_0x69079e], {
      distance: _0x3661e,
      isEnabled: (_0x3be8cd, _0x2f661d) => {
        const _0x4454a4 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistlaptop4',
          1,
          false,
          true
        )
        return _0x29d825.isActive && !_0x29d825.data.stairCaseOpen && _0x4454a4
      },
    })
    const _0x1605e1 = {
      id: 'vault_door_ceo',
      label: 'Hack',
      icon: _0x58d72f,
      NPXEvent: 'np-heists:vault:upperCEOKeypad',
    }
    const _0x4f4c88 = { radius: 4 }
    _0x1a26f0.addPeekEntryByTarget('heist_vault_door_ceo', [_0x1605e1], {
      distance: _0x4f4c88,
      isEnabled: (_0xf41643, _0x4857ac) => {
        const _0x333585 = _0x2e9b37.g.exports['np-inventory'].hasEnoughOfItem(
          'heistdecrypter_red',
          1,
          false,
          true
        )
        return _0x29d825.isActive && !_0x29d825.data.ceoOfficeOpen && _0x333585
      },
    })
    const _0x535df4 = {
      id: 'heist_vault_safe_ceo',
      label: 'Crack',
      icon: _0x514931,
      NPXEvent: 'np-heists:vault:upperSafeCrack',
    }
    const _0x336f82 = { radius: 4 }
    const _0x168660 = {
      distance: _0x336f82,
      isEnabled: (_0x948165, _0x475278) => {
        return _0x29d825.isActive && !_0x29d825.data.safeCracked
      },
    }
    _0x1a26f0.addPeekEntryByTarget(
      'heist_vault_safe_ceo',
      [_0x535df4],
      _0x168660
    )
    const _0x1f0298 = {
      id: 'heist_vault_pc_ceo',
      label: 'Enter Password',
      icon: 'passport',
      NPXEvent: 'np-heists:vault:upperPCPassword',
    }
    const _0x5bf847 = { radius: 4 }
    const _0x34c288 = {
      distance: _0x5bf847,
      isEnabled: (_0x4a3e18, _0x26eaca) => {
        return _0x29d825.isActive
      },
    }
    _0x1a26f0.addPeekEntryByTarget('heist_vault_pc_ceo', [_0x1f0298], _0x34c288)
    const _0x1a2165 = {
      id: 'heist_vault_pc',
      label: 'Open',
      icon: 'laptop',
      NPXEvent: 'np-heists:vault:upperPC',
    }
    const _0xaf0d97 = { radius: 4 }
    const _0x39664b = {
      distance: _0xaf0d97,
      isEnabled: (_0x4d14c2, _0x51fbe4) => {
        return _0x29d825.isActive
      },
    }
    _0x1a26f0.addPeekEntryByTarget('heist_vault_pc', [_0x1a2165], _0x39664b)
  }
  _0x288d26.on('np-heists:vault:upperKeypad', async () => {
    const _0x4a04d9 = {
      label: 'Security Code',
      icon: 'code',
      name: 'code',
    }
    const _0x3f0cf1 = await _0x2e9b37.g.exports['np-ui'].OpenInputMenu(
      [_0x4a04d9],
      (_0x335f9d) => _0x335f9d && _0x335f9d.code
    )
    if (!_0x3f0cf1) {
      return
    }
    await _0x4547b9(1)
    if (_0x3f0cf1.code !== _0x29d825.data.upperKeypadCode) {
      emit('DoLongHudText', 'Incorrect Code', 2)
      return
    }
    emit('inventory:DegenItemType', 33, 'heistlaptop4')
    const _0x5c9607 = _0x109f88('minigames'),
      _0x293035 = _0x28bca6(Object.assign({}, _0x5c9607.vault['laptop-upper'])),
      _0x2c8c22 = GetEntityCoords(PlayerPedId(), true)
    _0x57a4f3(_0x2c8c22, 250, _0x293035)
    const _0x744ac9 = await _0x293035
    if (!_0x744ac9) {
      return
    }
    emit('inventory:DegenItemType', 100, 'heistlaptop4')
    await _0x349e09.execute('np-heists:vault:upperKeypadResult')
  })
  _0x288d26.on(
    'np-heists:vault:upperCageDoor',
    async (_0x548eee, _0x51f2ae, _0x43ecb1) => {
      var _0x320f01, _0x541b3f
      const _0x3df171 =
        (_0x320f01 = _0x43ecb1.zones.heist_vault_cagedoor) === null ||
        _0x320f01 === void 0
          ? void 0
          : _0x320f01.id
      if (!_0x3df171) {
        return
      }
      const _0x51e4ba =
        (_0x541b3f = _0x43ecb1.zones.heist_vault_cagedoor) === null ||
        _0x541b3f === void 0
          ? void 0
          : _0x541b3f.doorId
      emit('inventory:removeItem', 'thermitecharge', 1)
      const _0x11cbe2 = _0x109f88('minigames'),
        _0x468af3 = _0x322e53(
          Object.assign({}, _0x11cbe2.vault['door-thermite'])
        ),
        _0x354db5 = _0x124ede.fromArray(GetEntityCoords(PlayerPedId(), true)),
        _0x97ce21 = {
          x: _0x354db5.x,
          y: _0x354db5.y,
          z: _0x354db5.z,
          h: GetEntityHeading(PlayerPedId()),
        }
      _0x3cc3fa(_0x97ce21, 0, _0x468af3)
      const _0x535385 = await _0x468af3
      if (!_0x535385) {
        return
      }
      _0x288d26.emitNet('np-heists:vault:openCageDoor', _0x3df171, _0x51e4ba)
    }
  )
  _0x288d26.on('np-heists:vault:upperSafeCrack', async () => {
    const _0x3b1b7c = await _0x35679b(5)
    if (!_0x3b1b7c) {
      return
    }
    ClearPedTasksImmediately(PlayerPedId())
    await _0x349e09.execute('np-heists:vault:upperSafeCrackResult')
  })
  _0x288d26.on(
    'np-heists:vault:upperPC',
    async (_0x37319c, _0x7169ec, _0x52b4b1) => {
      var _0x5d94b7
      const _0x5e37cd = _0x52b4b1.zones.heist_vault_pc
      if (!_0x5e37cd) {
        return
      }
      const _0x384984 = _0x29d825.data.upperPCIdentifier[_0x5e37cd.id - 1],
        _0x5cffac = _0x29d825.data.upperPCPassword[_0x5e37cd.id - 1],
        _0x4d11f6 = {
          code: _0x5cffac ? _0x384984 + '-' + _0x5cffac : 'No Data Available',
        }
      const _0x3c3143 = {
        personal: false,
        whiteIconNames:
          (_0x5d94b7 = _0x5e37cd.whiteIconNames) !== null &&
          _0x5d94b7 !== void 0
            ? _0x5d94b7
            : 'on',
        isHeistPc: true,
        laptopBackground: _0x5e37cd.background,
        additionalFolders: _0x5e37cd.folders,
        additionalTextFiles: _0x5e37cd.textFiles,
        gameData: _0x4d11f6,
      }
      const _0x4e81ff = {
        enabledApps: ['heistApp'],
        enabledFeatures: [],
        overwriteSettings: _0x3c3143,
      }
      exports['np-ui'].openApplication('laptop', _0x4e81ff)
    }
  )
  _0x288d26.on('np-heists:vault:upperPCPassword', async () => {
    const _0x5c404f = _0x29d825.data.upperPCPassword
        .map((_0x1cfe70, _0x43deb0) => (_0x1cfe70 ? _0x43deb0 + 1 : -1))
        .filter((_0x597052) => _0x597052 !== -1),
      _0x465e21 = {
        label: '' + _0x5c404f[0],
        icon: 'passport',
        name: 'key1',
        maxLength: 2,
      }
    const _0x112344 = {
      label: '' + _0x5c404f[1],
      icon: 'passport',
      name: 'key2',
      maxLength: 2,
    }
    const _0x2313f6 = {
      label: '' + _0x5c404f[2],
      icon: 'passport',
      name: 'key3',
      maxLength: 2,
    }
    const _0x2e9e17 = {
      label: '' + _0x5c404f[3],
      icon: 'passport',
      name: 'key4',
      maxLength: 2,
    }
    const _0x258c88 = {
      label: '' + _0x5c404f[4],
      icon: 'passport',
      name: 'key5',
      maxLength: 2,
    }
    const _0x339863 = await _0x2e9b37.g.exports['np-ui'].OpenInputMenu(
      [_0x465e21, _0x112344, _0x2313f6, _0x2e9e17, _0x258c88],
      (_0x3ca5ea) =>
        _0x3ca5ea &&
        _0x3ca5ea.key1 &&
        _0x3ca5ea.key2 &&
        _0x3ca5ea.key3 &&
        _0x3ca5ea.key4 &&
        _0x3ca5ea.key5
    )
    if (!_0x339863) {
      return
    }
    await _0x4547b9(1)
    const _0x3e88bd = _0x29d825.data.upperPCPassword.filter(
      (_0x2e7c33) => _0x2e7c33
    )
    if (
      !Object.entries(_0x339863).every(([_0x32bf38, _0x2dddb3]) => {
        const _0x499d5f = +_0x32bf38.substring(3)
        return (
          _0x3e88bd[_0x499d5f - 1].toLowerCase() ===
          _0x2dddb3.toLowerCase().trim()
        )
      })
    ) {
      const _0x5742ec = {
        show: true,
        text: 'Invalid Password Detected!\nInitiating lockout sequence...\n            \nSuccess!',
      }
      exports['np-ui'].openApplication('textpopup', _0x5742ec)
      await _0x349e09.execute('np-heists:ui:stop', 'Heist Failed')
      return
    }
    const _0x3e1eec = {
      show: true,
      text: 'Gate Keycode: ' + _0x29d825.data.upperKeypadCode,
    }
    exports['np-ui'].openApplication('textpopup', _0x3e1eec)
  })
  _0x288d26.on(
    'np-heists:vault:upperCEOKeypad',
    async (_0x4cce44, _0x274d44, _0x400286) => {
      emit('inventory:DegenItemType', 26, 'heistdecrypter_red')
      const _0x3d611a = _0x109f88('minigames'),
        _0x44d6e3 = await _0x562cba(Object.assign({}, _0x3d611a.vault.untangle))
      if (!_0x44d6e3) {
        return
      }
      _0x349e09.execute('np-heists:vault:upperCEOKeypadResult')
    }
  )
  const _0x29d825 = new _0x5a531b(function () {}, 1000),
    _0x3246b0 = async () => {
      const _0x3908c6 = {
        x: 285.7,
        y: 264.98,
        z: 103.28,
      }
      const _0x61d926 = {
        heading: 162,
        minZ: 103.28,
        maxZ: 107.28,
      }
      _0x399ff7.addBoxZone(
        'vault',
        'fleeca_box_zone',
        _0x3908c6,
        1.9,
        2.2,
        _0x61d926
      )
      await _0x5b288c()
      await _0x2999f5()
      await _0x9519f6()
    },
    _0x204c1d = async (_0x115598, _0x1bdd65, _0x54224d, _0x577db6) => {
      const _0x59067d = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), true)
        ),
        _0x1ea6e2 = _0x124ede.fromArray([285.7, 264.98, 105.78]),
        _0x30c8d2 = _0x59067d.getDistance(_0x1ea6e2)
      if (_0x30c8d2 > 2.5) {
        return
      }
      if (!_0x4c7581 || _0x4c7581.heistActive) {
        emit('DoLongHudText', 'You cant do that at the moment! (Group)', 2)
        return
      }
      const _0x11ed02 = {
        label: 'Encryption Code',
        name: 'code',
      }
      const _0x597a7e = await _0x2e9b37.g.exports['np-ui'].OpenInputMenu(
        [_0x11ed02],
        (_0x3e2c09) => _0x3e2c09 && _0x3e2c09.code
      )
      if (!_0x597a7e) {
        return
      }
      const _0x44f7ef = await _0x349e09.execute(
        'np-heists:vault:canRob',
        _0x597a7e.code
      )
      if (!_0x44f7ef) {
        emit('DoLongHudText', 'Unavailable', 2)
        return
      }
      emit('inventory:removeItem', 'thermitecharge', 1)
      const _0x40b353 = {
          x: _0x1ea6e2.x,
          y: _0x1ea6e2.y,
          z: _0x1ea6e2.z,
          h: GetEntityHeading(PlayerPedId()),
        },
        _0x119dd7 = _0x109f88('minigames'),
        _0x489fd2 = _0x322e53(Object.assign({}, _0x119dd7.vault.thermite))
      _0x3cc3fa(_0x40b353, 0, _0x489fd2)
      const _0x1e051c = await _0x489fd2
      if (!_0x1e051c) {
        return
      }
      const _0x436e9c = { code: _0x597a7e.code }
      const _0x2982c1 = await _0x349e09.execute(
        'np-heists:startHeist',
        'vault',
        _0x436e9c
      )
    }
  _0x288d26.onNet('np-heists:vault:start', (_0x49a0d6) => {
    _0x29d825.data = _0x49a0d6
    _0x29d825.start()
  })
  _0x288d26.onNet('np-heists:vault:stop', () => {
    _0x29d825.stop()
  })
  _0x288d26.onNet('np-heists:vault:update', (_0x1f7fdd) => {
    _0x29d825.data = _0x1f7fdd
  })
  const _0xdb40b0 = async (_0x16e2f0, _0x439a25, _0x2cb939, _0x4000b4) => {
    var _0x516114
    const _0x37eb62 = JSON.parse(_0x439a25)
    if (!_0x37eb62) {
      return
    }
    const _0x28a95f = _0x37eb62.encryptionId
    if (!_0x28a95f) {
      return
    }
    const _0x48e0bd = _0x124ede.fromArray(_0x37eb62.coords)
    if (!_0x48e0bd) {
      return
    }
    const _0x19ad86 = _0x124ede.fromArray(
      GetEntityCoords(GetPlayerPed(PlayerId()), false)
    )
    if (!_0x19ad86) {
      return
    }
    if (_0x19ad86.getDistance(_0x48e0bd) < 150) {
      emit('DoLongHudText', 'Too close to signaling station!', 2)
      return
    }
    const _0x1fb070 = GetInteriorFromEntity(PlayerPedId())
    if (_0x1fb070) {
      emit('DoLongHudText', 'Unable to acquire signal!', 2)
      return
    }
    let _0x216b8c =
      (_0x516114 = _0x37eb62.numHacks) !== null && _0x516114 !== void 0
        ? _0x516114
        : 1
    const _0x2734ac = { police: true }
    const _0x2ffe94 = {
      dispatchCode: '10-90',
      displayCode: '10-90VG',
      skipMapping: false,
      recipientList: _0x2734ac,
      isImportant: true,
      playSound: true,
      soundName: 'HighPrioCrime',
      priority: 1,
      dispatchMessage: 'Anti-theft device tampering',
      text: 'An anti-theft device from a bank has been tampered with!',
      origin: _0x19ad86,
    }
    emit('dispatch:svNotify', _0x2ffe94)
    let _0x41f361
    switch (_0x28a95f) {
      case 'flip':
        const _0x142d50 = {}
        ;(_0x142d50.gridSize = 4),
          (_0x142d50.gameTimeoutDuration = 10000),
          (_0x41f361 = _0x1fae28(_0x142d50))
        break
      case 'untangle':
        const _0x408403 = {}
        ;(_0x408403.numPoints = 10),
          (_0x408403.gameTimeoutDuration = 16000),
          (_0x41f361 = _0x562cba(_0x408403))
        break
      case 'ddr':
        const _0x2e0d28 = {}
        ;(_0x2e0d28.letters = ['w', 'a', 's', 'd']),
          (_0x2e0d28.gameTimeoutDuration = 35000),
          (_0x2e0d28.failureCount = 5),
          (_0x2e0d28.timeBetweenLetters = 550),
          (_0x2e0d28.timeToTravel = 1200),
          (_0x2e0d28.columns = 4),
          (_0x41f361 = _0xd70562(_0x2e0d28))
        break
      case 'maze':
        const _0x50e8ac = {}
        ;(_0x50e8ac.gridSize = 5),
          (_0x50e8ac.gameTimeoutDuration = 15000),
          (_0x50e8ac.numberHideDuration = 5000),
          (_0x41f361 = _0x20c641(_0x50e8ac))
        break
      case 'var':
        const _0xbc469e = {}
        ;(_0xbc469e.numberTimeout = 4000),
          (_0xbc469e.squares = 7),
          (_0x41f361 = _0xe267e1(_0xbc469e))
        break
      case 'thermite':
        const _0x532b07 = {}
        ;(_0x532b07.gridSize = 5),
          (_0x532b07.coloredSquares = 12),
          (_0x532b07.gameTimeoutDuration = 15000),
          (_0x41f361 = _0x322e53(_0x532b07))
        break
    }
    const _0x2ccbb7 = await _0x41f361
    if (!_0x2ccbb7) {
      return
    }
    if (--_0x216b8c <= 0) {
      emit(
        'inventory:removeItemByMetaKV',
        'heistloot_tracked',
        1,
        '_remove_id',
        _0x37eb62['_remove_id']
      )
      _0x37eb62['_description'] = 'Serial: ' + _0x37eb62.id
      emit(
        'player:receiveItem',
        'heistloot',
        1,
        false,
        {},
        JSON.stringify(_0x37eb62)
      )
      return
    }
    emit('DoLongHudText', 'The encryption is stronger than normal!', 2)
    _0x37eb62.numHacks = _0x216b8c
    emit(
      'inventory:updateItem',
      _0x16e2f0,
      _0x4000b4,
      JSON.stringify(_0x37eb62)
    )
  }
  async function _0x21068c() {}
  on('np-inventory:itemUsed', (_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d) => {
    switch (_0x4b3ee6) {
      case 'advlockpick':
        _0x339194(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d)
        break
      case 'thermitecharge':
        _0x3c2493(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d),
          _0x204c1d(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d),
          _0x6e6489(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d)
        break
      case 'heistlaptop3':
        _0x1a3cbf(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d)
        break
      case 'heistbox':
        _0x16e4df(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d)
        break
      case 'heistloot_tracked':
        _0xdb40b0(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d)
        break
      case 'jammingdevice':
        _0x50e068(_0x4b3ee6, _0x3db1e8, _0x46f3a1, _0x1c636d)
        break
    }
  })
  on('np-spawn:characterSpawned', (_0x20bf46) => {
    _0x587760.reset()
  })
  async function _0x4a4c6b() {}
  const _0x34fa92 = async (_0xe2bbf3) => {
      const _0x3bac73 = await _0x349e09.execute(
        'np-heists:peds:createPed',
        _0xe2bbf3
      )
      return _0x3bac73
    },
    _0x48ff07 = async (_0x47a2c8) => {
      var _0x9f1ac7, _0x5a673c
      const _0x46c535 = GetVehicleModelNumberOfSeats(_0x47a2c8.model),
        _0x4f9a5f = 1 + Math.floor(Math.random() * _0x46c535)
      ;(_0x9f1ac7 = (_0x5a673c = _0x47a2c8.peds).amount) !== null &&
      _0x9f1ac7 !== void 0
        ? _0x9f1ac7
        : (_0x5a673c.amount = _0x4f9a5f)
      const _0x4051ae = await _0x349e09.execute(
        'np-heists:peds:createVehicle',
        _0x47a2c8.model,
        _0x47a2c8.coords,
        _0x47a2c8.heading,
        _0x47a2c8
      )
      return _0x4051ae
    }
  _0x288d26.onNet(
    'np-heists:peds:vehicleCreated',
    async (_0x36e8fc, _0x1dd722) => {
      await _0x5ae501.waitForCondition(() => {
        return NetworkDoesEntityExistWithNetworkId(_0x36e8fc)
      }, 30000)
      const _0x256312 = NetworkGetEntityFromNetworkId(_0x36e8fc)
      if (!_0x256312) {
        _0x288d26.emitNet('np-heists:peds:deleteVehicle', _0x36e8fc)
        return
      }
      IsThisModelAHeli(_0x1dd722.model) && SetHeliBladesSpeed(_0x256312, 1)
      console.log(
        'Created vehicle with netId ' +
          _0x36e8fc +
          ' | ' +
          _0x256312 +
          ' | ' +
          _0x1dd722
      )
      const _0x59197b = _0x1dd722.coords
      _0x59197b.x += 5
      _0x59197b.y += 5
      for (let _0x5dae50 = 0; _0x5dae50 < _0x1dd722.peds.amount; _0x5dae50++) {
        const _0x3a6960 = await _0x34fa92(_0x1dd722.peds)
        if (!_0x3a6960) {
          await _0x4547b9(5000)
          _0x5dae50 = _0x5dae50 - 1
          continue
        }
        _0x288d26.emitNet(
          'np-heists:peds:seatIntoVehicle',
          _0x36e8fc,
          NetworkGetNetworkIdFromEntity(_0x3a6960),
          _0x5dae50 - 1,
          _0x1dd722.seatOptions
        )
      }
    }
  )
  _0x288d26.onNet('np-heists:peds:pedCreated', async (_0x5a25aa, _0x4bdf2b) => {
    var _0xb6d9ee,
      _0x5c8e40,
      _0x2442e4,
      _0x50ba79,
      _0x40e4b3,
      _0xe14b93,
      _0x21a4dd,
      _0x546dfe,
      _0x3d076d,
      _0x1f009,
      _0x565edb,
      _0x2d6dd8,
      _0x17f378,
      _0x4951fc,
      _0x5d284a,
      _0x338e9a,
      _0x371a64,
      _0x12e936,
      _0x2aceb7,
      _0x4e2f1d,
      _0x508483,
      _0x2ac04d,
      _0x38b46a,
      _0x3173dc,
      _0x42e9be
    await _0x5ae501.waitForCondition(() => {
      return NetworkDoesEntityExistWithNetworkId(_0x5a25aa)
    }, 30000)
    console.log('Created ped with netId: ' + _0x5a25aa)
    const _0x3c4222 = NetworkGetEntityFromNetworkId(_0x5a25aa)
    DecorSetBool(_0x3c4222, 'ScriptedPed', true)
    SetEntityAsMissionEntity(_0x3c4222, true, true)
    const _0x534db3 = _0x4bdf2b.options
    SetEntityMaxHealth(
      _0x3c4222,
      (_0xb6d9ee = _0x534db3.health) !== null && _0xb6d9ee !== void 0
        ? _0xb6d9ee
        : 200
    )
    SetEntityHealth(
      _0x3c4222,
      (_0x5c8e40 = _0x534db3.health) !== null && _0x5c8e40 !== void 0
        ? _0x5c8e40
        : 200
    )
    SetPedArmour(
      _0x3c4222,
      (_0x2442e4 = _0x534db3.armour) !== null && _0x2442e4 !== void 0
        ? _0x2442e4
        : 0
    )
    SetPedSuffersCriticalHits(
      _0x3c4222,
      (_0x50ba79 = _0x534db3.criticalHits) !== null && _0x50ba79 !== void 0
        ? _0x50ba79
        : true
    )
    for (const [_0xcc47d5, _0x1b29a5] of (_0x40e4b3 = _0x534db3.weapons) !==
      null && _0x40e4b3 !== void 0
      ? _0x40e4b3
      : []) {
      GiveWeaponToPed(_0x3c4222, _0xcc47d5, _0x1b29a5, false, true)
      SetPedAmmo(_0x3c4222, _0xcc47d5, _0x1b29a5)
      SetAmmoInClip(_0x3c4222, _0xcc47d5, _0x1b29a5)
    }
    SetCanAttackFriendly(
      _0x3c4222,
      (_0xe14b93 = _0x534db3.attackFriendly) !== null && _0xe14b93 !== void 0
        ? _0xe14b93
        : false,
      (_0x21a4dd = !_0x534db3.attackFriendly) !== null && _0x21a4dd !== void 0
        ? _0x21a4dd
        : true
    )
    if (_0x534db3.combatAttributes) {
      SetPedCombatMovement(
        _0x3c4222,
        (_0x546dfe = _0x534db3.combatAttributes.movementType) !== null &&
          _0x546dfe !== void 0
          ? _0x546dfe
          : 0
      )
      SetPedCombatRange(
        _0x3c4222,
        (_0x3d076d = _0x534db3.combatAttributes.combatRange) !== null &&
          _0x3d076d !== void 0
          ? _0x3d076d
          : 0
      )
      SetPedAccuracy(
        _0x3c4222,
        (_0x1f009 = _0x534db3.combatAttributes.accuracy) !== null &&
          _0x1f009 !== void 0
          ? _0x1f009
          : 0
      )
      SetPedCanRagdoll(
        _0x3c4222,
        (_0x565edb = _0x534db3.combatAttributes.ragdoll) !== null &&
          _0x565edb !== void 0
          ? _0x565edb
          : true
      )
      SetPedCanRagdollFromPlayerImpact(
        _0x3c4222,
        (_0x2d6dd8 = _0x534db3.combatAttributes.ragdoll) !== null &&
          _0x2d6dd8 !== void 0
          ? _0x2d6dd8
          : true
      )
      SetPedCanPeekInCover(
        _0x3c4222,
        (_0x17f378 = _0x534db3.combatAttributes.useCover) !== null &&
          _0x17f378 !== void 0
          ? _0x17f378
          : true
      )
      SetPedCanSwitchWeapon(
        _0x3c4222,
        (_0x4951fc = _0x534db3.combatAttributes.swapWeapon) !== null &&
          _0x4951fc !== void 0
          ? _0x4951fc
          : true
      )
      SetPedCanEvasiveDive(
        _0x3c4222,
        (_0x5d284a = _0x534db3.combatAttributes.dive) !== null &&
          _0x5d284a !== void 0
          ? _0x5d284a
          : true
      )
      for (const [_0x2e898d, _0x8dcf39] of (_0x338e9a =
        _0x534db3.combatAttributes.pedFlags) !== null && _0x338e9a !== void 0
        ? _0x338e9a
        : []) {
        SetPedConfigFlag(_0x3c4222, _0x2e898d, _0x8dcf39)
      }
    }
    const _0x3d1a00 =
      (_0x371a64 = _0x534db3.relationshipGroup) !== null && _0x371a64 !== void 0
        ? _0x371a64
        : 'CIVILIAN'
    SetPedRelationshipGroupHash(_0x3c4222, GetHashKey(_0x3d1a00))
    SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(
      (_0x12e936 = _0x534db3.relationshipType) !== null && _0x12e936 !== void 0
        ? _0x12e936
        : 3,
      GetHashKey(_0x3d1a00),
      GetHashKey('PLAYER')
    )
    SetRelationshipBetweenGroups(
      (_0x2aceb7 = _0x534db3.relationshipType) !== null && _0x2aceb7 !== void 0
        ? _0x2aceb7
        : 3,
      GetHashKey('PLAYER'),
      GetHashKey(_0x3d1a00)
    )
    SetPedDropsWeaponsWhenDead(
      _0x3c4222,
      (_0x4e2f1d = _0x534db3.dropWeapon) !== null && _0x4e2f1d !== void 0
        ? _0x4e2f1d
        : false
    )
    _0x534db3.randomVariation && SetPedRandomComponentVariation(_0x3c4222, 1)
    _0x534db3.randomProps && SetPedRandomProps(_0x3c4222)
    SetPedSeeingRange(
      _0x3c4222,
      (_0x508483 = _0x534db3.combatAttributes.seeingRange) !== null &&
        _0x508483 !== void 0
        ? _0x508483
        : 200
    )
    SetPedHearingRange(
      _0x3c4222,
      (_0x2ac04d = _0x534db3.combatAttributes.hearingRange) !== null &&
        _0x2ac04d !== void 0
        ? _0x2ac04d
        : 150
    )
    SetPedAlertness(
      _0x3c4222,
      (_0x38b46a = _0x534db3.combatAttributes.alertness) !== null &&
        _0x38b46a !== void 0
        ? _0x38b46a
        : 3
    )
    StopPedSpeaking(
      _0x3c4222,
      (_0x3173dc = _0x534db3.stopSpeaking) !== null && _0x3173dc !== void 0
        ? _0x3173dc
        : true
    )
    DisablePedPainAudio(
      _0x3c4222,
      (_0x42e9be = _0x534db3.stopPainAudio) !== null && _0x42e9be !== void 0
        ? _0x42e9be
        : true
    )
    ClearPedTasksImmediately(_0x3c4222)
    SetEntityLoadCollisionFlag(_0x3c4222, true)
    if (!HasCollisionLoadedAroundEntity(_0x3c4222)) {
      const [_0x5277b9, _0x4be5f0, _0x66aac1] = GetEntityCoords(
        _0x3c4222,
        false
      )
      RequestCollisionAtCoord(_0x5277b9, _0x4be5f0, _0x66aac1)
    }
  })
  _0x288d26.onNet(
    'np-heists:peds:setPedIntoVehicle',
    async (_0x2c81b5, _0x1ec131, _0x48df06, _0x43513c) => {
      console.log(
        'Set ped into vehicle with netId: ' +
          _0x1ec131 +
          ', ' +
          _0x2c81b5 +
          ', ' +
          _0x48df06 +
          ', ' +
          _0x43513c
      )
      const _0x5e14e1 = await _0x5ae501.waitForCondition(() => {
        return (
          NetworkDoesEntityExistWithNetworkId(_0x1ec131) &&
          NetworkDoesEntityExistWithNetworkId(_0x2c81b5)
        )
      }, 30000)
      if (_0x5e14e1) {
        return
      }
      const _0x29689d = NetworkGetEntityFromNetworkId(_0x1ec131),
        _0xa8b871 = NetworkGetEntityFromNetworkId(_0x2c81b5)
      SetPedIntoVehicle(_0x29689d, _0xa8b871, _0x48df06)
      const _0x187bd2 = GetPlayerFromServerId(_0x43513c.targetPlayer),
        _0x18ead5 = _0x187bd2 ? GetPlayerPed(_0x187bd2) : PlayerPedId()
      if (_0x43513c.chase && _0x48df06 === -1) {
        TaskVehicleChase(_0x29689d, _0x18ead5)
        SetPedKeepTask(_0x29689d, true)
      } else {
        _0x43513c.combat && TaskCombatPed(_0x29689d, _0x18ead5, 0, 16)
      }
    }
  )
  async function _0x162c37() {}
  var _0x2b0acc
  ;(function (_0x4ec653) {
    _0x4ec653.INACTIVE = 'inactive'
    _0x4ec653.PREPARING = 'preparing'
    _0x4ec653.BOATING = 'boating'
    _0x4ec653.CLEARING = 'clearing'
    _0x4ec653.ACTIVE = 'active'
    _0x4ec653.FINISHED = 'finished'
  })(_0x2b0acc || (_0x2b0acc = {}))
  const _0x3807e0 = () => {
    _0x1bcfab.addHook('preStart', () => {
      const _0x351e86 = {
        x: -3559.01,
        y: 7368.38,
        z: 70,
      }
      const _0x4ce89a = { heading: 0 }
      _0x399ff7.addBoxZone(
        'oil_rig',
        'oilrig_zone',
        _0x351e86,
        1500,
        1500,
        _0x4ce89a
      )
    })
    _0x399ff7.onEnter('oilrig_zone', async (_0x17c75f) => {
      if (_0x2ebecf === _0x2b0acc.BOATING) {
        _0x349e09.execute('np-heists:oilrig:nextPhase', 'clearing')
      }
    })
    _0x288d26.onNet('np-heists:oilrig:spawnClearingPeds', async () => {
      const _0x70d01a = _0x124ede.fromArray([-3565.27, 7342.92, 32.54]),
        _0x3f1761 = {
          movementType: 3,
          combatRange: 1,
          accuracy: 1,
          ragdoll: false,
          pedFlags: [[208, true]],
        }
      const _0x137c61 = {
        health: 175,
        armour: 5,
        weapons: [
          [1192676223, 9999],
          [-1813897027, 9999],
        ],
        criticalHits: true,
        attackFriendly: false,
        combatAttributes: _0x3f1761,
        relationshipGroup: 'HATES_PLAYER',
        relationshipType: 5,
        dropWeapon: false,
        randomVariation: true,
        randomProps: true,
      }
      const _0x2c5f11 = _0x137c61,
        _0xe28fb = {
          model: GetHashKey('s_m_m_marine_01'),
          coords: _0x70d01a,
          heading: 0,
          options: _0x2c5f11,
        }
      await _0x34fa92(_0xe28fb)
    })
  }
  const _0x3acf8a = GetHashKey('patrolboat'),
    _0x191e11 = new Set(),
    _0x1ba274 = () => {
      _0x1bcfab.addHook('preStart', () => {
        const _0x54154a = {
          x: -3559.01,
          y: 7368.38,
          z: 70,
        }
        const _0x89ab33 = { heading: 0 }
        _0x399ff7.addBoxZone(
          'boat_zone',
          'oilrig_boat_zone',
          _0x54154a,
          6500,
          3500,
          _0x89ab33
        )
      })
      _0x1bcfab.addHook('active', async () => {
        if (_0x2ebecf !== _0x2b0acc.BOATING) {
          return
        }
        if (!_0x399ff7.isActive('oilrig_boat_zone')) {
          return
        }
        if (!_0x1bcfab.canTick('boat_tick')) {
          return
        }
        const _0x3c6849 = GetGamePool('CVehicle')
        let _0x12f17e = 0
        for (const _0xd14dc6 of _0x3c6849) {
          const _0x3c17bf = GetEntityModel(_0xd14dc6)
          if (!IsThisModelABoat(_0x3c17bf)) {
            continue
          }
          if (_0x3c17bf !== _0x3acf8a) {
            continue
          }
          const _0x4aabdd = GetPedInVehicleSeat(_0xd14dc6, -1)
          if (
            !_0x4aabdd ||
            IsPedAPlayer(_0x4aabdd) ||
            IsPedDeadOrDying(_0x4aabdd, true)
          ) {
            continue
          }
          _0x12f17e++
        }
        _0x1bcfab.setNextTick('boat_tick', 15)
        if (_0x12f17e > 5) {
          return
        }
        const _0x281b11 = _0x124ede.fromArray(
          GetEntityCoords(PlayerPedId(), true)
        )
        let _0x1866d4
        do {
          const _0xd9ab0d = _0x5ae501.getRandomNumber(0, 360) * (Math.PI / 180),
            _0x44689b = _0x281b11.add(
              new _0x124ede(
                Math.cos(_0xd9ab0d) * 350,
                Math.sin(_0xd9ab0d) * 350,
                0
              )
            ),
            [_0x58f503, _0x29fe6c] = TestVerticalProbeAgainstAllWater(
              _0x44689b.x,
              _0x44689b.y,
              _0x44689b.z,
              32,
              1
            )
          if (!_0x58f503) {
            continue
          }
          _0x44689b.z = _0x29fe6c
          _0x1866d4 = _0x44689b
        } while (!_0x1866d4)
        _0x1866d4.z || (_0x1866d4.z = 5)
        const _0x34ef6a = {
          movementType: 3,
          combatRange: 1,
          accuracy: 1,
          ragdoll: false,
          pedFlags: [[208, true]],
        }
        const _0x2269f8 = {
          health: 175,
          armour: 100,
          weapons: [
            [1192676223, 9999],
            [-1813897027, 9999],
          ],
          criticalHits: false,
          attackFriendly: false,
          combatAttributes: _0x34ef6a,
          relationshipGroup: 'HATES_PLAYER',
          relationshipType: 5,
          dropWeapon: false,
          randomVariation: true,
          randomProps: true,
        }
        const _0x1cc718 = _0x2269f8,
          _0x3e4e8c = await _0x48ff07({
            peds: {
              model: GetHashKey('s_m_m_marine_01'),
              amount: 4,
              coords: _0x1866d4,
              heading: 69,
              options: _0x1cc718,
            },
            coords: _0x1866d4,
            heading: 69,
            model: GetHashKey('patrolboat'),
            seatOptions: {
              chase: true,
              combat: true,
              targetPlayer: GetPlayerServerId(PlayerId()),
            },
          })
        _0x191e11.add(_0x3e4e8c)
      })
      _0x1bcfab.addHook('active', () => {
        if (!_0x1bcfab.canTick('boat_cleanup')) {
          return
        }
        _0x1bcfab.setNextTick('boat_cleanup', 30)
        const _0x4dbde8 = GetGamePool('CVehicle'),
          _0x288969 = _0x4dbde8.map((_0x5f129c) => {
            const _0x2294f7 = GetEntityModel(_0x5f129c)
            if (_0x2294f7 !== _0x3acf8a) {
              return
            }
            return NetworkGetNetworkIdFromEntity(_0x5f129c)
          })
        for (const _0x45f757 of _0x191e11.values()) {
          if (
            _0x288969.find((_0x454bbb) => _0x454bbb === _0x45f757) &&
            IsVehicleDriveable(NetworkGetEntityFromNetworkId(_0x45f757), true)
          ) {
            continue
          }
          _0x191e11.delete(_0x45f757)
          _0x288d26.emitNet('np-heists:peds:deleteVehicle', _0x45f757)
        }
      })
      _0x1bcfab.addHook('afterStop', () => {
        for (const _0x23c68d of _0x191e11.values()) {
          _0x288d26.emitNet('np-heists:peds:deleteVehicle', _0x23c68d)
        }
        _0x191e11.clear()
      })
    }
  let _0x2ebecf = _0x2b0acc.INACTIVE
  const _0x1bcfab = new _0x5a531b(function () {}, 1000)
  async function _0x661a93() {
    _0x1ba274()
    _0x3807e0()
  }
  const _0x2dd777 = async (_0x40da40) => {
    if (_0x1bcfab.isActive) {
      await _0x1bcfab.stop()
    }
    await _0x1bcfab.start()
    _0x2ebecf = _0x40da40.phase
  }
  _0x288d26.onNet('np-heists:oilrig:start', _0x2dd777)
  _0x288d26.onNet('np-heists:oilrig:nextPhase', (_0x5195bd) => {
    _0x2ebecf = _0x5195bd
  })
  async function _0x4a78db() {
    await _0x661a93()
    await _0xa9b9d2()
    await _0x2d0f45()
    await _0x5a3144()
    await _0x3246b0()
    await _0x36bed3()
  }
  async function _0x1fd6f1() {
    await _0x4cb156()
    await _0x21068c()
    await _0x162c37()
    await _0x4a4c6b()
    await _0x22539f()
    await _0x4a78db()
    await _0x5432d6()
    _0x18b57f()
  }
  ;(async () => {
    await _0x1fd6f1()
  })()
})()
