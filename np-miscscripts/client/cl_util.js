class AnimationTask {
    constructor(pPed, pType, pTxt, pDur, pDict, pAnim, pFlag = 1) {
        this.ped = pPed;
        this.type = pType;
        this.flag = pFlag;
        this.text = pTxt;
        this.active = false;
        this.duration = pDur;
        this.dictionary = pDict;
        this.animation = pAnim;
    }
    start(pTask) {
        if (this.active)
            return;
        this.active = true;
        if (pTask) {
            pTask(this);
        }
        this.tickId = setTick(async () => {
            if (this.animation && !IsEntityPlayingAnim(this.ped, this.dictionary, this.animation, 3)) {
                await NPX.Streaming.loadAnim(this.dictionary);
                TaskPlayAnim(this.ped, this.dictionary, this.animation, -8.0, -8.0, -1, this.flag, 0, false, false, false);
            }
            else if (!this.animation && !IsPedUsingScenario(this.ped, this.dictionary)) {
                TaskStartScenarioInPlace(this.ped, this.dictionary, 0, true);
            }
            await new Promise((resolve) => setTimeout(resolve, 100));
        });
        let task;
        if (this.type === 'skill' && this.duration instanceof Array) {
            task = new Promise(async (resolve) => {
                const skills = this.duration;
                for (const skill of skills) {
                    const progress = await TaskbarMiniGame(skill.difficulty, skill.gap);
                    if (progress !== 100)
                        return resolve(0);
                }
                resolve(100);
            });
        }
        else if (this.type === 'normal' && typeof this.duration === 'number') {
            task = Taskbar(this.duration, this.text);
        }
        task.then(() => {
            this.stop();
        });
        return task;
    }
    stop() {
        if (!this.active)
            return;
        this.active = false;
        clearTick(this.tickId);
        if (!this.animation && IsPedUsingScenario(this.ped, this.dictionary)) {
            ClearPedTasks(this.ped);
        }
        else {
            StopAnimTask(this.ped, this.dictionary, this.animation, 3.0);
        }
    }
    abort() {
        if (this.active) {
            exports['np-taskbar'].taskCancel();
            this.stop();
        }
    }
}

function Taskbar(pLength, pName, pRunCheck = false) {
    return new Promise((resolve) => {
        if (pName) {
            exports['np-taskbar'].taskBar(pLength, pName, pRunCheck, true, null, false, resolve);
        }
        else {
            setTimeout(() => resolve(100), pLength);
        }
    });
}
function TaskbarMiniGame(pDifficulty, pGap) {
    return new Promise((resolve) => {
        exports['np-ui'].taskBarSkill(pDifficulty, pGap, resolve);
    });
}