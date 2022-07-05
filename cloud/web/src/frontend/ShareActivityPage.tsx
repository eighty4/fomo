import ActivityForm from './ActivityForm'
import FomoPage from './FomoPage'

import type {NextPage} from 'next'

const ShareActivityPage: NextPage = () => {

    return <FomoPage>
        <div style={{margin: '30px'}}>
            <ActivityForm/>
        </div>
    </FomoPage>
}

export default ShareActivityPage
