function shuffle(array) {
  var currentIndex = array.length, temporaryValue, randomIndex;

  // While there remain elements to shuffle...
  while (0 !== currentIndex) {

    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;

    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }

  return array;
}

const VideoFiles = [];

for (let i = 1; i < 32; i++) {
  VideoFiles.push(`intro${i}.webm`);
}

shuffle(VideoFiles);

const videos = [];
const intervalTimer = 4000;

let previousDiv;
let previousId = -1;
let usedIds = [];
let intervalId;
let isThreadActive = false;

const playVideo = (video) => {
    video.pause();
    video.currentTime = 0;
    video.play();
}

const startThread = () => {
    if (isThreadActive) return;

    isThreadActive = true;

    let id;
    let div;
    let video;

    const playVideoLoopFn = () => {
      if (previousDiv) {
          previousDiv.style.opacity = 0;
      }
      id = Math.floor(Math.random() * videos.length);
      while (usedIds.indexOf(id) !== -1 || previousId === id) {
        id = Math.floor(Math.random() * videos.length);
      }
      usedIds.push(id);
      if (usedIds.length === videos.length) {
        usedIds = [];
      }
      div = videos[id];
      video = [...div.children][0];
      div.style.opacity = 1;

      if (div) playVideo(video);

      previousId = id;
      previousDiv = div;
    }

    intervalId = setInterval(playVideoLoopFn, intervalTimer);

    playVideoLoopFn();
}

let cancelI;
const startApp = () => {
    const app = HTMLDivElement = document.getElementById('app');

    for (const file of VideoFiles) {
        const req = new XMLHttpRequest();

        const div = document.createElement('div');
        div.classList.add('video');
        app.appendChild(div);

        const video = document.createElement('video');
        video.style.maxWidth = "100vw";
        video.style.minWidth = "100vw";

        div.appendChild(video)

        req.open('GET', `videos/${file}`, true);

        req.responseType = 'blob';

        req.onload = function () {
            if (this.status !== 200) return;

            const blob = this.response;

            video.src = URL.createObjectURL(blob);

            videos.push(div);

            cancelI = setInterval(() => {
              if (videos.length > 0) {
                clearInterval(cancelI);
                startThread();
              }
            }, 100);
        }

        req.send();
    }
}

const stopThread = () => {
    clearInterval(intervalId);
}

startApp();
