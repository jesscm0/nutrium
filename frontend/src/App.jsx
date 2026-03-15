import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Nutritionists from './pages/Nutritionists';
import Appointments from './pages/Appointments';

function App() {

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Nutritionists />} />
        <Route path="/appointments" element={<Appointments />} />
      </Routes>
    </BrowserRouter>
  )

}

export default App