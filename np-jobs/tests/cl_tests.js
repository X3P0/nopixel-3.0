function GetEntityInFrontOfPed(distance, ped) {
    const [aX, aY, aZ] = GetEntityCoords(ped, false);
    const [oX, oY, oZ] = GetEntityForwardVector(ped);
    const [tX, tY, tZ] = [aX + oX * distance, aY + oY * distance, aZ + oZ * distance];

    const handle = StartShapeTestRay(aX, aY, aZ, tX, tY, tZ, -1, ped, 0);
    const [retval, hit, endCoords, surfaceNormal, entity] = GetShapeTestResult(handle);

    return entity;
}

RegisterCommand('requestTow', (src) => {
    const entity = GetEntityInFrontOfPed(5.0, PlayerPedId());
    
    if (DoesEntityExist(entity) === 1) {
        SetEntityAsMissionEntity(entity, true, true)
        const netId = NetworkGetNetworkIdFromEntity(entity);
        emitNet('np:jobs:towtruck:request', netId);
    }
}, false);


RegisterCommand('checkIn', (src, args) => {
    const jobId = args[0];
    exports['np-jobs'].JobCheckIn(jobId);
},false);

RegisterCommand('checkOut', (src, args) => {
    exports['np-jobs'].JobCheckOut();
},false);
