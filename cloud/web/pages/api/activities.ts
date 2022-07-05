import {saveActivity} from '../../src/backend/saveActivity'

import type {NextApiRequest, NextApiResponse} from 'next'

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
    switch (req.method) {
        case 'POST':
            await saveActivity(req, res)
            break
        default:
            res.status(405).send(`no ${req.method}`)
            break
    }
}
