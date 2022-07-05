import {FC, Fragment, PropsWithChildren} from 'react'
import Head from 'next/head'

const FomoPage: FC<PropsWithChildren> = ({children}) => {
    return <Fragment>
        <Head>
            <title>Fomo</title>
            <meta name="description" content="An app for finding fun"/>
            <link rel="icon" href="/favicon.ico"/>
        </Head>
        {children}
    </Fragment>
}

export default FomoPage
