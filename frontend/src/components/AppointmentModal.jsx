import { Dialog, DialogPanel, DialogTitle, DialogBackdrop } from '@headlessui/react';
import { useTranslation } from "react-i18next";
import { useState } from 'react'

export default function AppointmentModal({ open, setOpen, catalog }) {
    const { t } = useTranslation();
    const [formData, setFormData] = useState({
        first_name: '',
        last_name: '',
        email: '',
        date: '',
        time: ''
    });
    console.log(catalog)

    const clearForm = (e) => {
        setFormData({
        first_name: '',
        last_name: '',
        email: '',
        date: '',
        time: ''
    })
    }

    const handleSubmit = (e) => {
        e.preventDefault();

        const body = {
            guest_email: formData.email,
            guest_first_name: formData.first_name,
            guest_last_name: formData.last_name,
            date: new Date(`${formData.date}T${formData.time}`).toISOString(),
            nutritionist_id: catalog?.nutritionist?.id,
            service_id: catalog?.service?.id,
            district_id: catalog?.district?.id
        }

        console.log(body);


        fetch('http://localhost:3000/api/v1/appointments', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        })
            .then(async res => {
                const data = await res.json();

                if (res.ok) {
                    alert(t("appointmentScheduled"));
                    setOpen(false);
                } else {
                    const errorMessage = data.errors ? data.errors.join(", ") : "Generic Error";
                    alert(errorMessage);
                }
            })
            .catch(err => {
                console.error(" Error:", err);
                alert(t("errorScheduling"));
            });



    }

    return (
        <Dialog open={open} onClose={() => { setOpen(false); setFormData({}) }} className="relative z-50">
            <DialogBackdrop className="fixed inset-0 bg-black/50 transition-opacity" />

            <div className="fixed inset-0 z-10 w-screen overflow-y-auto flex items-center justify-center p-4">
                <DialogPanel className="w-full max-w-lg transform overflow-hidden rounded-lg bg-white p-8 shadow-xl transition-all">

                    <DialogTitle as="h3" className="text-xl font-bold text-slate-800 border-b pb-4">
                        {t("scheduleAppointment")}
                    </DialogTitle>

                    <form onSubmit={handleSubmit} className="mt-6 space-y-5">

                        {/* Nome e Apelido */}
                        <div className="grid grid-cols-2 gap-4">
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("firstname")}</span>
                                <input type="text"
                                    required
                                    value={formData.first_name}
                                    onChange={(e) => setFormData({ ...formData, first_name: e.target.value })}
                                    placeholder="John"
                                    className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("lastName")}</span>
                                <input type="text"
                                    required
                                    value={formData.last_name}
                                    onChange={(e) => setFormData({ ...formData, last_name: e.target.value })}
                                    placeholder="Doe" className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                        </div>

                        {/* Email  */}
                        <div className="flex flex-col gap-1">
                            <span className="text-sm font-semibold text-slate-700">{t("email")}</span>
                            <input type="email"
                                required
                                value={formData.email}
                                onChange={(e) => setFormData({ ...formData, email: e.target.value })}


                                placeholder="john@example.com"
                                className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                        </div>

                        {/* Data e Hora */}
                        <div className="grid grid-cols-2 gap-4">
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("date")}</span>
                                <input type="date"
                                    required
                                    value={formData.date}
                                    onChange={(e) => setFormData({ ...formData, date: e.target.value })}

                                    className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                            <div className="flex flex-col gap-1">
                                <span className="text-sm font-semibold text-slate-700">{t("time")}</span>
                                <input type="time"
                                    required
                                    value={formData.time}
                                    onChange={(e) => setFormData({ ...formData, time: e.target.value })}
                                    className="px-3 py-2 border border-slate-300 rounded-md text-sm focus:ring-2 focus:ring-nutrium-green outline-none" />
                            </div>
                        </div>

                        {/* Botões */}
                        <div className="mt-8 flex justify-end gap-3 border-t pt-6">
                            <button
                                type="button"
                                onClick={() => { clearForm(); setOpen(false); }}
                                className="px-4 py-2 text-sm font-medium text-slate-600 hover:text-slate-800"
                            >
                                {t("cancel")}
                            </button>
                            <button
                                type="submit"
                                onClick={() => { console.log("Submitted") }}
                                className="bg-nutrium-green hover:bg-nutrium-green-darker text-white px-6 py-2 rounded-md font-bold text-sm shadow-sm transition-colors"
                            >
                                {t("saveAppointment")}
                            </button>
                        </div>
                    </form>

                </DialogPanel>
            </div>
        </Dialog>
    );
}
