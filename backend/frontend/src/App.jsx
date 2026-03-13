import { useEffect, useState } from 'react'

function App() {
  const [dados, setDados] = useState([])

  useEffect(() => {
    // Faz o pedido ao backend (Rails)
    fetch('/api/guests') // Substitui 'tasks' pelo nome de uma tabela tua
      .then(res => res.json())
      .then(data => setDados(data))
      .catch(err => console.error("Erro:", err))
  }, [])

  return (
    <div style={{ padding: '20px' }}>
      <h1>Ligação React + Rails</h1>
      <ul>
        {dados.map((item, index) => (
          <li key={index}>{JSON.stringify(item)}</li>
        ))}
      </ul>
    </div>
  )
}

export default App