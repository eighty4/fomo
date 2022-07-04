import {Client} from '@elastic/elasticsearch'

import type {NextApiRequest, NextApiResponse} from 'next'

interface Activity {
    title: string
}

const es = new Client({
    nodes: 'http://localhost:9200',
})

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

async function saveActivity(req: NextApiRequest, res: NextApiResponse) {
    if (!req.headers['content-type']
        || req.headers['content-type'].indexOf('application/json') === -1) {
        res.status(415).send('send json')
        return
    }
    const activity: Activity = {
        title: req.body.title,
    }
    if (!activity.title || !activity.title.length) {
        res.status(400).send('missing title')
        return
    }
    try {
        await es.index({
            index: 'activities',
            document: activity,
            refresh: 'true',
        })
        res.status(201).send('')
    } catch (e: any) {
        res.status(500).send(e.message)
    }
}
