import {Client} from '@elastic/elasticsearch'

import type {Activity} from '../Activity'
import type {NextApiRequest, NextApiResponse} from 'next'

const es = new Client({
    nodes: 'http://localhost:9200',
})

export async function saveActivity(req: NextApiRequest, res: NextApiResponse) {
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
            index: 'fomo-activities-submitted',
            document: activity,
            refresh: 'true',
        })
        res.status(201).send('')
    } catch (e: any) {
        res.status(500).send(e.message)
    }
}
