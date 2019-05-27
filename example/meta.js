module.exports = {
  prompts: {
    name: {
      type: 'string',
      required: true,
      message: 'Application name:',
    },
    // 'author' is always prompted regardless of what you put in here, but we can turn this behavior off with 'when'
    author: {
      when: 'false',
    },
  },
};
