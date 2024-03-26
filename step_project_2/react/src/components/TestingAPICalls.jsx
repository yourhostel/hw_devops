import React, { useEffect, useState } from 'react'
import { FetchData } from '../utils/Services'

const TestingAPICalls = () => {

  const [data, setData] = useState([])
  useEffect(() => {
      FetchData().then(data => {
          setData(data);  
      })
  })

  return data.map(item => (
    <div key="{item.name}">
        <div>
            {item.name}
        </div>
    </div>
    )
  )
}

export default TestingAPICalls