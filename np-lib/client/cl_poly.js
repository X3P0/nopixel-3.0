class PolyZone {
    static addBoxZone(pId, pCenter, pLength, pWidth, pOptions) {
        exports['np-polyzone'].AddBoxZone(pId, pCenter, pLength, pWidth, pOptions);
    }

    static addCircleZone(pId, pCenter, pRadius, pOptions) {
        exports['np-polyzone'].AddCircleZone(pId, pCenter, pRadius, pOptions);
    }
}

class PolyTarget {
    static addBoxZone(pId, pCenter, pLength, pWidth, pOptions) {
        exports['np-polytarget'].AddBoxZone(pId, pCenter, pLength, pWidth, pOptions);
    }

    static addCircleZone(pId, pCenter, pRadius, pOptions) {
        exports['np-polytarget'].AddCircleZone(pId, pCenter, pRadius, pOptions);
    }
}
