import FomoPage from './FomoPage'
import Link from 'next/link'
import Image from 'next/image'

import type {NextPage} from 'next'

import styles from './HomePage.module.css'

const HomePage: NextPage = () => {

    return <FomoPage>

        <div className={styles.container}>

            <main className={styles.main}>
                <h1>{'<fomo>'}</h1>
                <ul className={styles.links}>
                    <Link href="/activity/share">share an activity</Link>
                </ul>
                <h1>{'</fomo>'}</h1>
            </main>

            <footer className={styles.footer}>
                <a
                    href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
                    target="_blank"
                    rel="noopener noreferrer"
                >
                    Powered by{' '}
                    <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16}/>
          </span>
                </a>
            </footer>
        </div>
    </FomoPage>
}

export default HomePage
