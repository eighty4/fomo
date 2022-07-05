import {useForm} from 'react-hook-form'
import {useState} from 'react'

import type {Activity} from '../Activity'

import styles from './ActivityForm.module.css'

const ActivityForm = () => {

    const [completed, setCompleted] = useState(false)

    const {
        register,
        handleSubmit,
        formState,
        watch,
    } = useForm({
        defaultValues: {
            title: '',
            location: '',
            scheduling: 'once',
            explicitly: '',
            weekly: 'MON',
        },
    })

    if (completed) {
        return <div className={styles.section}>
            <label className={styles.label}>
                Thanks for your submission
            </label>
            <p className={styles.description}>
                We'll email you once your activity has been reviewed!
            </p>
        </div>
    }

    const onSubmit = (formData: any) => {
        const activity: Activity = {
            title: formData.title,
        }
        const req = {
            method: 'POST',
            body: JSON.stringify(activity),
            headers: {
                'content-type': 'application/json',
            },
        }
        fetch('/api/activities', req)
            .then(r => {
                if (r.status !== 201) {
                    r.text().then(console.log)
                } else {
                    setCompleted(true)
                }
            })
            .then(console.log)
    }

    const schedulingType = watch('scheduling')
    let schedulingInput
    switch (schedulingType) {
        case 'once':
            schedulingInput = <input className={styles.date}
                                     placeholder="09/16/2022"
                                     {...register('explicitly', {required: true})}/>
            break
        case 'weekly':
            schedulingInput = <select {...register('weekly', {required: true})}>
                <option value="MON">Monday</option>
                <option value="TUE">Tuesday</option>
                <option value="WED">Wednesday</option>
                <option value="THU">Thursday</option>
                <option value="FRI">Friday</option>
                <option value="SAT">Saturday</option>
                <option value="SUN">Sunday</option>
            </select>
            break
    }

    return <form className={styles.form} onSubmit={handleSubmit(onSubmit)}>

        <section className={styles.section}>
            <label className={styles.label} htmlFor="title-input">What</label>
            <span className={styles.description}>A label for search and display in the Fomo app</span>
            <input id="title-input"
                   className={styles.input}
                   placeholder="Marble League Team Tryouts"
                   autoFocus
                   {...register('title', {required: true})}/>
        </section>

        <section className={styles.section}>
            <label className={styles.label} htmlFor="location-input">Where</label>
            <span className={styles.description}>Search by place, business or address</span>
            <input id="location-input"
                   className={styles.input}
                   placeholder="Grant Park, Empty Bottle, 111 S Michigan Ave"
                   {...register('location', {required: true})}/>
        </section>

        <section className={styles.section}>
            <label className={styles.label} htmlFor="scheduling-input">When</label>
            <span className={styles.description}>Your activity happens <select
                id="scheduling-input" {...register('scheduling', {required: true})}>
                <option value="once">once</option>
                <option value="weekly">weekly</option>
            </select> on {schedulingInput}</span>
        </section>

        <section className={styles.section}>
            <p>
                Your activity will be saved in our database for review.
                <br/>
                Upon approval, you'll see it in the Fomo app!
            </p>
            <button type="submit">Share</button>
        </section>

    </form>
}

export default ActivityForm
