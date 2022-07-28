global.exports('getGemData', (str) => {
  const count = Number(str.split(' ')[0]);
  return { count };
});
