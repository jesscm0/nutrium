import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Catalogs from './pages/Catalogs';
import Appointments from './pages/Appointments';

function App() {

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Catalogs />} />
        <Route path="/appointments" element={<Appointments />} />
      </Routes>
    </BrowserRouter>
  )

}

export default App