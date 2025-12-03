const request = require('supertest')
const url = process.env.RELEASE_URL
test('release endpoint responds ok', async () => {
  if (!url) return
  const res = await request(url).get('/api')
  expect(res.statusCode).toBe(200)
})
